class TeamStatsPresenter
  attr_accessor :users, :filter_start_time, :filter_end_time, :plan_id, :actual_id

  def initialize(args)
    args = defaults.merge(args)
    @users = args[:users]
    @filter_start_time = args[:filter_start_date].to_time.in_time_zone.beginning_of_day
    @filter_end_time = args[:filter_end_date].to_time.in_time_zone.end_of_day
    @plan_id = args[:plan_id]
    @actual_id = args[:actual_id]
  end

  def average_weekly_planned_per_month
    first_days_of_months.map do |first_day_of_month|
      {
        'name': first_day_of_month.strftime('%B'),
        'value': users.map { |user|
          UserStatsPresenter.new(
            user: user,
            filter_start_date: first_day_of_month,
            filter_end_date: first_day_of_month.end_of_month
          ).average_weekly_planned
        }.sum
      }
    end

    # For each month
      # sum the weekly planned for each user
      # UserStatsPresenter.new()
    # average_per_month(plan_id)
  end

  def average_weekly_actual_per_month
    # average_per_month(actual_id)
  end

  def percentage_delivered_per_month
    # percentage_per_month(total(actual_id), total(plan_id))
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

  def average_per_month(time_range_type_id)
    total = total(time_range_type_id)
    result = (total.to_f / number_of_weeks)
    return 0 if result.nan? || result.infinite?

    result.round(1)
  end

  def total(time_range_type_id)
    filtered_time_ranges(time_range_type_id).sum(&:value)
  end

  # def filtered_time_ranges(time_range_type_id)
  #   time_range_scope = user.time_ranges.where(time_range_type_id: time_range_type_id)
  #   time_range_scope = time_range_scope.where('start_time > ?', filter_start_time)
  #   time_range_scope.where('end_time < ?', filter_end_time)
  # end

  # def number_of_weeks
  #   filter_duration = filter_end_time - filter_start_time
  #   (filter_duration / 1.week)
  # end

  # def percentage(numerator, denominator)
  #   result = ((numerator.to_f / denominator) * 100)
  #   return 0 if result.nan? || result.infinite?

  #   result.round(0)
  # end

  def first_days_of_months
    days = (@filter_start_time.to_date..@filter_end_time.to_date)
    @first_days_of_months ||= days.map(&:beginning_of_month).uniq
  end
end
