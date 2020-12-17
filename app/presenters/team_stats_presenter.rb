class TeamStatsPresenter
  attr_accessor :filter_start_time, :filter_end_time, :plan, :actual

  def initialize(args)
    args = defaults.merge(args.compact)
    calculate_variables(args)
  end

  def calculate_variables(args)
    @filter_start_time = args[:filter_start_date].to_time.in_time_zone.beginning_of_day
    @filter_end_time = args[:filter_end_date].to_time.in_time_zone.end_of_day
    @plan = weekly_averages(time_ranges: plan_time_ranges(user_ids: args[:user_ids], tag_ids: args[:tag_ids]))
    @actual = weekly_averages(time_ranges: actual_time_ranges(time_range_type_id: args[:actual_id], user_ids: args[:user_ids], tag_ids: args[:tag_ids]))
  end

  def average_weekly_planned_per_month
    months.map { |month| response(month: month, value: plan[month] || 0) }
  end

  def average_weekly_actual_per_month
    months.map { |month| response(month: month, value: actual[month] || 0) }
  end

  def weekly_percentage_delivered_per_month
    months.map { |month| response(month: month, value: percentage(month: month)) }
  end

  private

  def response(month:, value:)
    {
      'name': month.strftime(I18n.t('time.formats.iso8601_utc')),
      'value': value,
      'notes': relevant_notes(month: month.strftime('%Y-%m'))
    }
  end

  def defaults
    {
      filter_start_date: 1.year.ago,
      filter_end_date: Time.zone.today,
      actual_id: TimeRangeType.actual_type.id
    }
  end

  def plan_time_ranges(user_ids:, tag_ids:)
    Activity.joins(:plan, :tag_associations)
            .where('plans.user_id': user_ids, 'tag_associations.tag_id': tag_ids)
            .distinct
            .flat_map(&:to_time_ranges)
  end

  def weekly_averages(time_ranges:)
    data = time_ranges.group_by(&:user_id).values
    data = user_weekly_averages_per_month(data: data)
    data = total_weekly_averages_per_month(data: data)
    data.transform_values { |v| v.round(1) } # Hide floating point errors.
  end

  def user_weekly_averages_per_month(data:)
    data.map do |user_time_ranges|
      per_month = calculate_monthly_values(time_ranges: user_time_ranges)

      # For each month, transform to the average weekly value for that month,
      # based on the number of weeks in that month.
      per_month.update(per_month) do |month, value|
        number_of_weeks = (month.end_of_month - month) / 1.week
        (value / number_of_weeks).round(1)
      end
    end
  end

  # Split time_range values across months, proportionally
  # according to how they overlap the edges of months.
  def calculate_monthly_values(time_ranges:)
    time_ranges.each_with_object(Hash.new(0)) do |t, per_month|
      months_between(from: t.start_time, to: t.end_time).each do |m|
        per_month[m] += t.segment_value(
          segment_start: m,
          segment_end: m.end_of_month
        ).to_f
      end

      per_month
    end
  end

  def total_weekly_averages_per_month(data:)
    # Sum to get totals of user weekly averages per month.
    data.each_with_object(Hash.new(0)) do |user_averages, memo|
      user_averages.each { |month, value| memo[month] += value }
      memo
    end
  end

  def notes
    @notes ||= Note.where(start_time: filter_start_time..filter_end_time)
                   .group_by { |n| n.start_time.strftime('%Y-%m') }
  end

  # Indexes hit:
  # 1 user: index_time_ranges_on_user_id
  # Up to 50% of users: index_time_range_team_stats
  # >50% of users: index_time_ranges_on_time_range_type_id
  def actual_time_ranges(time_range_type_id:, user_ids:, tag_ids:)
    scope = TimeRange.select(:time_range_type_id, :user_id, :start_time, :end_time, :value)
                     .where(time_range_type_id: time_range_type_id, user_id: user_ids)
                     .joins(:tag_associations)
                     .where('tag_associations.tag_id': tag_ids)

    scope.where('start_time BETWEEN ? AND ?', filter_start_time, filter_end_time).or(
      scope.where('end_time BETWEEN ? AND ?', filter_start_time, filter_end_time)
    ).or(
      scope.where('start_time <= ? AND end_time >= ?', filter_start_time, filter_end_time)
    ).distinct.to_a
  end

  def months
    @months ||= months_between(from: filter_start_time, to: filter_end_time)
  end

  def months_between(from:, to:)
    (from.to_date..to.to_date)
      .map(&:beginning_of_month)
      .uniq
      .map { |m| m.to_time.in_time_zone }
  end

  def percentage(month:)
    return 0 if @actual[month].nil? || @plan[month].nil? || @plan[month].zero?

    ((@actual[month] / @plan[month]) * 100).round(2)
  end

  def relevant_notes(month:)
    # TODO: Filter by subject, and later viewer permissions.
    (notes[month] || []).map(&:with_author).to_json
  end
end
