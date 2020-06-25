class DashboardPresenter
  def initialize(args)
    @params = args[:params]
  end

  def paginated_users
    User.page(@params[:page])
  end

  def bar_chart(user_ids:, plan_id:, actual_id:)
    User.find(user_ids).map do |user|
      {
        'name': user.name,
        'value': bar_chart_value(user: user, plan_id: plan_id, actual_id: actual_id)
      }
    end
  end

  def to_json(*_args)
    {
      bar_chart: bar_chart(
        user_ids: User.pluck(:id),
        plan_id: TimeRangeType.find_by(name: 'Job Plan').id,
        actual_id: TimeRangeType.find_by(name: 'RIO Data').id
      )
    }.to_json
  end

  private

  def bar_chart_value(user:, plan_id:, actual_id:)
    if user.time_ranges.any?
      plan_total = user.time_ranges.where(time_range_type_id: plan_id).sum(&:value)
      actual_total = user.time_ranges.where(time_range_type_id: actual_id).sum(&:value)
      ((actual_total.to_f / plan_total) * 100).to_i
    end
  end
end
