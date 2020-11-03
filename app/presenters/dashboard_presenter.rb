class DashboardPresenter
  def initialize(args)
    args[:params] = defaults.merge(args[:params].to_hash.symbolize_keys)
    @params = args[:params]
  end

  def paginated_users
    User.where(id: @params[:user_ids]).page(@params[:page])
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
        user_ids: @params[:user_ids],
        actual_id: @params[:actual_id]
      ).weekly_percentage_delivered_per_month
    ]
  end

  def admin_data
    4.times.map do
      admin_x_axis.map do |month|
        {
          name: month,
          value: rand(8.0..14.0).round(2),
          notes: [].to_json
        }
      end
    end
  end

  def to_json(args)
    args[:graphs].each_with_object({}) do |graph, hash|
      hash[graph[:type]] = {
        data: send(graph[:data]),
        units: graph[:units]
      }
      hash
    end.to_json
  end

  private

  def bar_chart_value(user:)
    return if user.time_ranges.none?

    UserStatsPresenter.new(
      user: user,
      actual_id: @params[:actual_id]
    ).percentage_delivered
  end

  def defaults
    {
      user_ids: User.ids,
      actual_id: TimeRangeType.actual_type.id
    }
  end

  def admin_x_axis
    (5..10).map do |month|
      Time.zone.local(2020, month, 1).strftime(I18n.t('time.formats.iso8601_utc'))
    end
  end
end
