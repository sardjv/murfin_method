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

  def line_graph(user_ids:, plan_id:, actual_id:)
    TeamStatsPresenter.new(
      users: User.find(user_ids),
      plan_id: plan_id,
      actual_id: actual_id
    ).weekly_percentage_delivered_per_month
  end

  def to_json(*_args)
    user_ids = User.pluck(:id)
    plan_id = TimeRangeType.plan_type.id
    actual_id = TimeRangeType.actual_type.id
    {
      bar_chart: bar_chart(user_ids: user_ids, plan_id: plan_id, actual_id: actual_id),
      line_graph: bar_chart(user_ids: user_ids, plan_id: plan_id, actual_id: actual_id)
    }.to_json
  end

  private

  def bar_chart_value(user:, plan_id:, actual_id:)
    return if user.time_ranges.none?

    UserStatsPresenter.new(user: user, plan_id: plan_id, actual_id: actual_id).percentage_delivered
  end
end
