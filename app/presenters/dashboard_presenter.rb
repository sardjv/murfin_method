class DashboardPresenter
  def initialize(args)
    @params = args[:params]
  end

  def paginated_users
    User.page(@params[:page])
  end

  def bar_chart(user_ids:, plan_id:, actual_id:)
    User.find(user_ids).map do |user|
      plan_total = user.time_ranges.where(time_range_type_id: plan_id).sum(&:value)
      actual_total = user.time_ranges.where(time_range_type_id: actual_id).sum(&:value)
      byebug
      {
        'name': user.name,
        'value': actual_total / plan_total
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
end
