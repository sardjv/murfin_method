class UserStatsPresenter
  attr_accessor :user, :filter_start_time, :filter_end_time, :plan_id, :actual_id

  OVER_MIN_PERCENTAGE = 120
  OK_MIN_PERCENTAGE = 80
  UNDER_MIN_PERCENTAGE = 50

  def initialize(args)
    args = defaults.merge(args)
    @user = args[:user]
    @filter_start_time = args[:filter_start_date].to_time.in_time_zone.beginning_of_day
    @filter_end_time = args[:filter_end_date].to_time.in_time_zone.end_of_day
    @actual_id = args[:actual_id]
    @cache = {}
  end

  def average_weekly_planned
    return nil if no_planned_data?

    average_weekly(planned_time_ranges)
  end

  def average_weekly_actual
    return nil if no_actual_data?

    average_weekly(actual_time_ranges(actual_id))
  end

  def percentage_delivered
    return nil if no_planned_data? || no_actual_data?

    percentage(total(actual_time_ranges(actual_id)), total(planned_time_ranges))
  end

  def status
    percentage = percentage_delivered
    # no planned or actual data - Unknown
    return I18n.t('status.unknown') if percentage.nil?
    # 120+ - Over
    return I18n.t('status.over') if percentage >= OVER_MIN_PERCENTAGE
    # 80 to 119 - About Right
    return I18n.t('status.about_right') if percentage >= OK_MIN_PERCENTAGE
    # 50 to 79 - Under
    return I18n.t('status.under') if percentage >= UNDER_MIN_PERCENTAGE

    # 0 to 49 - Really Under
    I18n.t('status.really_under')
  end

  def actual_time_ranges(time_range_type_id)
    return @cache[:actual_time_ranges] if @cache[:actual_time_ranges].present?

    @cache[:actual_time_ranges] = calculate_actual_time_ranges(time_range_type_id)
  end

  def planned_time_ranges
    return @cache[:planned_time_ranges] if @cache[:planned_time_ranges].present?

    @cache[:planned_time_ranges] = calculate_planned_time_ranges
  end

  def total(time_ranges)
    time_ranges.sum do |t|
      t.segment_value(
        segment_start: filter_start_time,
        segment_end: filter_end_time
      )
    end
  end
  # TODO: move to TimeRange class ?

  private

  def defaults
    {
      filter_start_date: (1.year.ago + 1.day).beginning_of_day,
      filter_end_date: Time.zone.today.end_of_day,
      actual_id: TimeRangeType.actual_type.id
    }
  end

  def average_weekly(time_ranges)
    total = total(time_ranges)
    result = (total.to_f / number_of_weeks)
    return 0 if result.nan? || result.infinite?

    result.round(1)
  end

  def number_of_weeks
    (filter_end_time - filter_start_time) / 1.week
  end

  def percentage(numerator, denominator)
    result = ((numerator.to_f / denominator) * 100)
    return 0 if result.nan? || result.infinite?

    result.round(0)
  end

  def no_planned_data?
    planned_time_ranges.empty?
  end

  def no_actual_data?
    actual_time_ranges(actual_id).empty?
  end

  def calculate_actual_time_ranges(time_range_type_id)
    scope = user.time_ranges.where(time_range_type_id: time_range_type_id)

    scope.where('start_time BETWEEN ? AND ?', filter_start_time, filter_end_time).or(
      scope.where('end_time BETWEEN ? AND ?', filter_start_time, filter_end_time)
    ).or(
      scope.where('start_time <= ? AND end_time >= ?', filter_start_time, filter_end_time)
    ).to_a
  end

  def calculate_planned_time_ranges
    Plan.where(user_id: user.id).flat_map(&:to_time_ranges).select do |a|
      Intersection.call(
        a_start: a.start_time,
        a_end: a.end_time,
        b_start: filter_start_time,
        b_end: filter_end_time
      ).positive?
    end
  end
end
