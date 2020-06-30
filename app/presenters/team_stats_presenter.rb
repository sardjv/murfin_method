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
          ).average_weekly_planned || 0
        }.sum
      }
    end
  end

  def average_weekly_actual_per_month
    first_days_of_months.map do |first_day_of_month|
      {
        'name': first_day_of_month.strftime('%B'),
        'value': users.map { |user|
          UserStatsPresenter.new(
            user: user,
            filter_start_date: first_day_of_month,
            filter_end_date: first_day_of_month.end_of_month
          ).average_weekly_actual || 0
        }.sum
      }
    end
  end

  def percentage_delivered_per_month
    first_days_of_months.map.with_index do |first_day_of_month, index|
      actual = average_weekly_actual_per_month[index][:value]
      plan = average_weekly_planned_per_month[index][:value]
      value = (plan.zero? ? 0 : actual / plan)

      {
        'name': first_day_of_month.strftime('%B'),
        'value': value
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

  def first_days_of_months
    days = (@filter_start_time.to_date..@filter_end_time.to_date)
    @first_days_of_months ||= days.map(&:beginning_of_month).uniq
  end
end
