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
    @average_weekly_planned_per_month ||= bounds_of_months.map do |from, to|
      {
        'name': from.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': total(users: users, from: from, to: to, method: :average_weekly_planned),
        'note_ids': relevant_notes(from: from, to: to)
      }
    end
  end

  def average_weekly_actual_per_month
    @average_weekly_actual_per_month ||= bounds_of_months.map do |from, to|
      {
        'name': from.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': total(users: users, from: from, to: to, method: :average_weekly_actual),
        'note_ids': relevant_notes(from: from, to: to)
      }
    end
  end

  def weekly_percentage_delivered_per_month
    bounds_of_months.map.with_index do |bounds, index|
      {
        'name': bounds.first.strftime(I18n.t('time.formats.iso8601_utc')),
        'value': percentage(index),
        'note_ids': relevant_notes(from: bounds.first, to: bounds.last)
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

  def bounds_of_months
    days = (@filter_start_time.to_date..@filter_end_time.to_date)
    @bounds_of_months ||= days.map { |d| [d.beginning_of_month, d.end_of_month] }.uniq
  end

  def total(users:, from:, to:, method:)
    users.sum do |user|
      UserStatsPresenter.new(
        user: user,
        filter_start_date: from,
        filter_end_date: to
      ).send(method) || 0
    end
  end

  def percentage(index)
    actual = average_weekly_actual_per_month[index][:value]
    plan = average_weekly_planned_per_month[index][:value]
    value = (plan.zero? ? 0 : (actual / plan) * 100)
    value.round(2)
  end

  def relevant_notes(from:, to:)
    # TODO: Filter by subject, and later viewer permissions.
    Note.where(start_time: from..to).pluck(:id)
  end
end
