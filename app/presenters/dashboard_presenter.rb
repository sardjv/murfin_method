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

  def line_graph
    [
      { 'name': 'May', 'value': '50' },
      { 'name': 'June', 'value': '60' },
      { 'name': 'July', 'value': '70' },
      { 'name': 'August', 'value': '80' },
      { 'name': 'September', 'value': '80' },
      { 'name': 'October', 'value': '120' }
    ]
  end

  def to_json(*_args)
    {
      bar_chart: bar_chart(
        user_ids: User.pluck(:id),
        plan_id: TimeRangeType.plan_type.id,
        actual_id: TimeRangeType.actual_type.id
      ),
      line_graph: line_chart(
        user_ids: User.pluck(:id),
        plan_id: TimeRangeType.plan_type.id,
        actual_id: TimeRangeType.actual_type.id
      )
    }.to_json
  end

  private

  def bar_chart_value(user:, plan_id:, actual_id:)
    return if user.time_ranges.none?

    UserStatsPresenter.new(user: user, plan_id: plan_id, actual_id: actual_id).percentage_delivered
  end
end
