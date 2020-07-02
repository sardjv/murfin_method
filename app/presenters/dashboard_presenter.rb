class DashboardPresenter
  def initialize(args)
    args[:params] = defaults.merge(args[:params])
    @params = args[:params]
  end

  def paginated_users
    User.page(@params[:page])
  end

  def bar_chart
    User.find(@params[:user_ids]).map do |user|
      {
        'name': user.name,
        'value': bar_chart_value(user: user)
      }
    end
  end

  def line_graph
    [
      TeamStatsPresenter.new(
        users: User.find(@params[:user_ids]),
        plan_id: @params[:plan_id],
        actual_id: @params[:actual_id]
      ).weekly_percentage_delivered_per_month
    ]
  end

  def multi_line_graph
    [
      [
        { name: 'June', value: 0 },
        { name: 'July', value: 0 },
        { name: 'August', value: 0 },
        { name: 'September', value: 0 },
        { name: 'October', value: 0 },
        { name: 'November', value: 0 },
        { name: 'December', value: 0 },
        { name: 'January', value: 0 },
        { name: 'February', value: 0 },
        { name: 'March', value: 0 },
        { name: 'April', value: 0 },
        { name: 'May', value: 0 },
        { name: 'June', value: 50.21 }
      ],
      [
        { name: 'June', value: 42.86 },
        { name: 'July', value: 41.81 },
        { name: 'August', value: 41.81 },
        { name: 'September', value: 41.81 },
        { name: 'October', value: 41.81 },
        { name: 'November', value: 41.81 },
        { name: 'December', value: 41.81 },
        { name: 'January', value: 41.81 },
        { name: 'February', value: 41.81 },
        { name: 'March', value: 41.81 },
        { name: 'April', value: 41.81 },
        { name: 'May', value: 41.81 },
        { name: 'June', value: 42.04 }
      ]
    ]
  end

  def to_json(args)
    args[:graphs].each_with_object({}) do |graph, hash|
      hash[graph] = send(graph)
      hash
    end.to_json
  end

  private

  def bar_chart_value(user:)
    return if user.time_ranges.none?

    UserStatsPresenter.new(
      user: user,
      plan_id: @params[:plan_id],
      actual_id: @params[:actual_id]
    ).percentage_delivered
  end

  def defaults
    {
      user_ids: User.pluck(:id),
      plan_id: TimeRangeType.plan_type.id,
      actual_id: TimeRangeType.actual_type.id
    }
  end
end
