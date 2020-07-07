class DashboardPresenter
  def initialize(args)
    args[:params] = defaults.merge(args[:params])
    @params = args[:params]
  end

  def paginated_users
    User.page(@params['page'])
  end

  def individual_data
    User.find(@params[:user_ids]).map do |user|
      {
        'name': user.name,
        'value': bar_chart_value(user: user)
      }
    end
  end

  def team_data
    [
      TeamStatsPresenter.new(
        users: User.find(@params[:user_ids]),
        plan_id: @params[:plan_id],
        actual_id: @params[:actual_id]
      ).weekly_percentage_delivered_per_month
    ]
  end

  def admin_data
    4.times.map do
      %w[May June July August September October].map do |month|
        {
          name: month,
          value: rand(8.0..14.0)
        }
      end
    end
  end

  def to_json(args)
    args[:graphs].each_with_object({}) do |graph, hash|
      hash[graph[:type]] = send(graph[:data])
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
