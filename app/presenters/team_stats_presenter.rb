# frozen_string_literal: true

class TeamStatsPresenter
  attr_accessor :filter_start_time, :filter_end_time, :filter_tag_ids, :graph_kind, :time_scope, :plan_id, :plan, :actual_id, :actual, :user_ids

  GRAPH_KINDS = %w[percentage_delivered planned_vs_actual].freeze
  TIME_SCOPES = %w[weekly monthly].freeze

  def initialize(args)
    args = defaults.merge(args.compact)
    cache(args)
  end

  def cache(args) # rubocop:disable Metrics/AbcSize
    @user_ids = args[:user_ids]
    @actual_id = args[:actual_id]
    @filter_tag_ids = args[:filter_tag_ids]
    @filter_start_date = args[:filter_start_date]
    @filter_end_date = args[:filter_end_date]
    @filter_start_time = @filter_start_date.to_time.in_time_zone.beginning_of_day
    @filter_end_time = @filter_end_date.to_time.in_time_zone.end_of_day
    @graph_kind = args[:graph_kind] || GRAPH_KINDS.first
    @time_scope = args[:time_scope] || TIME_SCOPES.first

    if @time_scope == 'monthly'
      @plan = weekly_averages_per_month(time_ranges: plan_time_ranges)
      @actual = weekly_averages_per_month(time_ranges: actual_time_ranges)
    elsif @time_scope == 'weekly'
      @plan = weekly_averages_per_week(time_ranges: plan_time_ranges)
      @actual = weekly_averages_per_week(time_ranges: actual_time_ranges)
    end
  end

  def average_weekly_planned_per_month
    months.map { |month| response(month: month, value: plan[month] || 0) }
  end

  def average_weekly_planned_per_week
    weeks.map { |week| response_week(week: week, value: plan[week] || 0) }
  end

  def average_weekly_actual_per_month
    months.map { |month| response(month: month, value: actual[month] || 0) }
  end

  def average_weekly_actual_per_week
    weeks.map { |week| response_week(week: week, value: actual[week] || 0) }
  end

  def weekly_percentage_delivered_per_month
    @weekly_percentage_delivered_per_month ||= months.map { |month| response(month: month, value: percentage(key: month)) }
  end

  def weekly_percentage_delivered_per_week
    @weekly_percentage_delivered_per_week ||= weeks.map { |week| response_week(week: week, value: percentage(key: week)) }
  end

  def average_delivery_percent
    if @time_scope == 'weekly'
      data = weekly_percentage_delivered_per_week
    elsif @time_scope == 'monthly'
      data = weekly_percentage_delivered_per_month
    end

    data_size = data&.size

    return 0 if data_size.zero?

    data_values_sum = data.sum { |e| e[:value] }
    (data_values_sum.to_f / data_size).round
  end

  def average_weekly_percentage_delivered_per_month
    data = weekly_percentage_delivered_per_month
    data_size = data&.size

    return 0 if data_size.zero?

    data_values_sum = data.sum { |e| e[:value] }
    (data_values_sum.to_f / data_size).round
  end

  def average_weekly_percentage_delivered_per_week
    data = weekly_percentage_delivered_per_week
    data_size = data&.size

    return 0 if data_size.zero?

    data_values_sum = data.sum { |e| e[:value] }
    (data_values_sum.to_f / data_size).round
  end

  def members_under_delivered_percent
    count = 0

    users = User.where(id: @user_ids)
    users.each do |user|
      pd = UserStatsPresenter.new(
        user: user,
        actual_id: @actual_id,
        filter_start_date: @filter_start_date,
        filter_end_date: @filter_end_date,
        filter_tag_ids: @filter_tag_ids
      ).percentage_delivered

      count += 1 if pd.is_a?(Numeric) && pd < UserStatsPresenter::OK_MIN_PERCENTAGE
    end

    count
  end

  def time_scope_options
    self.class::TIME_SCOPES
  end

  def graph_kind_options
    self.class::GRAPH_KINDS
  end

  # Indexes hit:
  # 1 user: index_time_ranges_on_user_id
  # Up to 50% of users: index_time_range_team_stats
  # >50% of users: index_time_ranges_on_time_range_type_id
  def actual_time_ranges
    scope = TimeRange.where(time_range_type_id: @actual_id, user_id: @user_ids)
    scope = scope.filter_by_tag_types_and_tags(@filter_tag_ids) if @filter_tag_ids.present?

    scope.where('start_time BETWEEN ? AND ?', @filter_start_time, @filter_end_time).or(
      scope.where('end_time BETWEEN ? AND ?', @filter_start_time, @filter_end_time)
    ).or(
      scope.where('start_time <= ? AND end_time >= ?', @filter_start_time, @filter_end_time)
    ).distinct
  end

  def weeks
    @weeks ||= weeks_between(from: @filter_start_time, to: @filter_end_time)
  end

  private

  def response(month:, value:)
    {
      'name': month.strftime(I18n.t('time.formats.iso8601_utc')),
      'value': value,
      'notes': relevant_notes(key: month.strftime('%Y-%m'))
    }
  end

  def response_week(week:, value:)
    {
      'name': week.strftime(I18n.t('time.formats.iso8601_utc')),
      'value': value,
      'notes': relevant_notes(key: week.strftime('%Y-%m-%d'))
    }
  end

  def defaults
    {
      filter_start_date: (1.year.ago + 1.day).beginning_of_day,
      filter_end_date: Time.zone.today.end_of_day,
      actual_id: TimeRangeType.actual_type.id
    }
  end

  def plan_time_ranges
    scope = Activity.joins(:plan)
                    .where(plans: { user_id: @user_ids })
                    .distinct
                    .preload(:plan)

    scope = scope.filter_by_tag_types_and_tags(@filter_tag_ids) if @filter_tag_ids.present?

    scope.flat_map(&:to_time_ranges)
  end

  def weekly_averages_per_month(time_ranges:)
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
        # how many minutes from time range overlaps given month
        per_month[m] += t.segment_value(segment_start: m, segment_end: m.end_of_month).to_f
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

  def weekly_averages_per_week(time_ranges:)
    data = time_ranges.group_by(&:user_id).values

    data = user_weekly_averages_per_week(data: data)
    data = total_weekly_averages_per_week(data: data)

    data.transform_values { |v| v.round(1) }
  end

  def user_weekly_averages_per_week(data:)
    data.map do |user_time_ranges|
      per_week = calculate_weekly_values(time_ranges: user_time_ranges)

      per_week
    end
  end

  # Split time_range values across weeks, proportionally
  # according to how they overlap the edges of weeks.
  def calculate_weekly_values(time_ranges:)
    time_ranges.each_with_object(Hash.new(0)) do |t, per_week|
      weeks_between(from: t.start_time, to: t.end_time).each do |m|
        per_week[m] += t.segment_value(segment_start: m, segment_end: m.end_of_week).to_f
      end

      per_week
    end
  end

  def total_weekly_averages_per_week(data:)
    # Sum to get totals of user weekly averages per week.
    data.each_with_object(Hash.new(0)) do |user_averages, memo|
      user_averages.each { |week, value| memo[week] += value }
      memo
    end
  end

  def notes
    notes_scope = Note.where(start_time: @filter_start_time..@filter_end_time)

    if @time_scope == 'weekly'
      @notes ||= notes_scope.group_by { |n| n.start_time.beginning_of_week.strftime('%Y-%m-%d') }
    elsif @time_scope == 'monthly'
      @notes ||= notes_scope.group_by { |n| n.start_time.strftime('%Y-%m') }
    end

    @notes
  end

  def months
    @months ||= months_between(from: @filter_start_time, to: @filter_end_time)
  end

  def months_between(from:, to:)
    raise ArgumentError, 'from must be before to' if from >= to

    (from.to_date..to.to_date)
      .map(&:beginning_of_month)
      .uniq
      .map { |m| m.to_time.in_time_zone }
  end

  def weeks_between(from:, to:)
    raise ArgumentError, 'from must be before to' if from >= to

    (from.to_date..to.to_date)
      .map(&:beginning_of_week)
      .uniq
      .map { |w| w.to_time.in_time_zone }
  end

  def percentage(key:)
    return 0 if @actual[key].nil? || @plan[key].nil? || @plan[key].zero?

    ((@actual[key] / @plan[key]) * 100).round(2)
  end

  def relevant_notes(key:)
    # TODO: Filter by subject, and later viewer permissions.
    (notes[key] || []).map(&:with_author).to_json
  end
end
