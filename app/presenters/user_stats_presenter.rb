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
    @plan_id = args[:plan_id]
    @actual_id = args[:actual_id]
  end

  def average_weekly_planned
    average_weekly(plan_id)
  end

  def average_weekly_actual
    average_weekly(actual_id)
  end

  def percentage_delivered
    percentage(total(actual_id), total(plan_id))
  end

  def status
    percentage = percentage_delivered
    return I18n.t('status.over') if percentage >= OVER_MIN_PERCENTAGE
    return I18n.t('status.about_right') if percentage >= OK_MIN_PERCENTAGE
    return I18n.t('status.under') if percentage >= UNDER_MIN_PERCENTAGE
    return I18n.t('status.really_under') if percentage.positive?

    I18n.t('status.unknown')
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

  def average_weekly(time_range_type_id)
    total = total(time_range_type_id)
    result = (total.to_f / number_of_weeks)
    return 0 if result.nan? || result.infinite?

    result.round(1)
  end

  def total(time_range_type_id)
    filtered_time_ranges(time_range_type_id).sum(&:value)
  end

  def filtered_time_ranges(time_range_type_id)
    time_range_scope = user.time_ranges.where(time_range_type_id: time_range_type_id)
    time_range_scope = time_range_scope.where('start_time > ?', filter_start_time)
    time_range_scope.where('end_time < ?', filter_end_time)
  end

  def number_of_weeks
    filter_duration = filter_end_time - filter_start_time
    (filter_duration / 1.week)
  end

  def percentage(numerator, denominator)
    result = ((numerator.to_f / denominator) * 100)
    return 0 if result.nan? || result.infinite?

    result.round(0)
  end
end
