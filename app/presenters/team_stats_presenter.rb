class TeamStatsPresenter
  attr_accessor :users, :filter_start_time, :filter_end_time, :plan_id, :actual_id

  def initialize(args)
    args = defaults.merge(args)
    @users = args[:users]
    @filter_start_time = args[:filter_start_date].to_time.in_time_zone.beginning_of_day
    @filter_end_time = args[:filter_end_date].to_time.in_time_zone.end_of_day
    @plan_id = args[:plan_id]
    @actual_id = args[:actual_id]

    @time_ranges = {}
    @time_ranges[@plan_id] = fetch_data(time_range_type_id: @plan_id)
    @time_ranges[@actual_id] = fetch_data(time_range_type_id: @actual_id)

    @notes = fetch_notes
  end

  def average_weekly_planned_per_month
    @time_ranges[@plan_id].map do |month, value|
      {
        'name': month.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': value,
        'notes': relevant_notes(month: month.strftime('%Y-%m'))
      }
    end
  end

  def average_weekly_actual_per_month
    @time_ranges[@actual_id].map do |month, value|
      {
        'name': month.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': value,
        'notes': relevant_notes(month: month.strftime('%Y-%m'))
      }
    end
  end

  def weekly_percentage_delivered_per_month
    months.map.with_index do |month, index|
      {
        'name': month.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': percentage(index),
        'notes': relevant_notes(month: month.strftime('%Y-%m'))
      }
    end
  end

  private

  def defaults
    {
      filter_start_date: 1.year.ago,
      filter_end_date: Time.zone.today,
      plan_id: TimeRangeType.plan_type.id,
      actual_id: TimeRangeType.actual_type.id
    }
  end

  def fetch_data(time_range_type_id:)
    data = relevant_time_ranges(time_range_type_id: time_range_type_id)
    data = data.group_by(&:user_id).values
    data = user_weekly_averages_per_month(data: data)
    data = total_weekly_averages_per_month(data: data)
    data = data.transform_values { |v| v.round(1) } # Hide floating point errors.
    data.merge(months_counter) { |_key, calculated, default| calculated || default } # Add empty months.
  end

  def user_weekly_averages_per_month(data:)
    data.map do |user_time_ranges|
      per_month = Hash.new(0)

      # For each user, split time_range values across months,
      # proportionally according to how they overlap the edges of months.
      user_time_ranges.each do |t|
        months = (t.start_time.to_date..t.end_time.to_date)
                 .map(&:beginning_of_month)
                 .uniq
                 .map(&:to_time)

        months.each do |m|
          per_month[m] += t.segment_value(
            segment_start: m,
            segment_end: m.end_of_month
          ).to_f
        end
      end

      # For each month, transform to the average weekly value for that month,
      # based on the number of weeks in that month.
      per_month.update(per_month) do |month, value|
        number_of_weeks = (month.end_of_month - month) / 1.week
        (value / number_of_weeks).round(1)
      end
    end
  end

  def total_weekly_averages_per_month(data:)
    # Sum to get totals of user weekly averages per month.
    data.inject(Hash.new(0)) do |memo, user_averages|
      user_averages.each { |month, value| memo[month] += value }
      memo
    end
  end

  def fetch_notes
    Note.where(start_time: @filter_start_time..@filter_end_time)
        .group_by { |n| n.start_time.strftime('%Y-%m') }
  end

  def relevant_time_ranges(time_range_type_id:)
    scope = TimeRange.where(user_id: users, time_range_type_id: time_range_type_id)
    scope.where('start_time BETWEEN ? AND ?', filter_start_time, filter_end_time).or(
      scope.where('end_time BETWEEN ? AND ?', filter_start_time, filter_end_time)
    ).or(
      scope.where('start_time <= ? AND end_time >= ?', filter_start_time, filter_end_time)
    ).to_a
  end

  def months
    (@filter_start_time.to_date..@filter_end_time.to_date).map(&:beginning_of_month).uniq
  end

  def months_counter
    Hash[months.map { |m| [m.to_time, 0] }]
  end

  def percentage(index)
    actual = average_weekly_actual_per_month[index][:value]
    plan = average_weekly_planned_per_month[index][:value]
    value = (plan.zero? ? 0 : (actual / plan) * 100)
    value.round(2)
  end

  def relevant_notes(month:)
    # TODO: Filter by subject, and later viewer permissions.
    (@notes[month] || []).map(&:with_author).to_json
  end
end
