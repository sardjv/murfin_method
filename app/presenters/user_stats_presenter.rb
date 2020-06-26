class UserStatsPresenter
  attr_accessor :user, :filter_start_time, :filter_end_time

  def initialize(args)
    @user = args[:user]
    filter_start_date = args[:filter_start_date] || 1.year.ago
    filter_end_date = args[:filter_end_date] || Time.zone.today
    @filter_start_time = filter_start_date.to_time.in_time_zone.beginning_of_day
    @filter_end_time = filter_end_date.to_time.in_time_zone.end_of_day
  end

  def average_weekly_planned
    average_weekly(TimeRangeType.plan_type)
  end

  def average_weekly_actual
    average_weekly(TimeRangeType.actual_type)
  end

  def percentage_delivered
    percentage(total(TimeRangeType.actual_type), total(TimeRangeType.plan_type))
  end

  def status; end

  private

  def average_weekly(time_range_type)
    total = total(time_range_type)
    result = (total.to_f / number_of_weeks)
    return 0 if result.nan? || result.infinite?

    result.round(0)
  end

  def total(time_range_type)
    filtered_time_ranges(time_range_type).sum(&:value)
  end

  def filtered_time_ranges(time_range_type)
    time_range_scope = user.time_ranges.where(time_range_type: time_range_type)
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
