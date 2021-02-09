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
    case @params[:graph_kind]
    when 'planned_vs_actual'
      [
        team_stats_presenter.average_weekly_planned_per_month,
        team_stats_presenter.average_weekly_actual_per_month
      ]
    else
      [team_stats_presenter.weekly_percentage_delivered_per_month]
    end
  end

  def team_stats_presenter
    @team_stats_presenter ||= TeamStatsPresenter.new(
      user_ids: @params[:user_ids],
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids,
      graph_kind: @params[:graph_kind]
    )
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
        units: graph[:units],
        dataset_labels: graph[:dataset_labels]
      }.delete_if { |_k, v| v.blank? }

      args[:extras].each do |name|
        hash[name] = @team_stats_presenter.send(name)
      end

      hash
    end.to_json
  end

  private

  def bar_chart_value(user:)
    return if user.time_ranges.none?

    UserStatsPresenter.new(
      user: user,
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date
    ).percentage_delivered
  end

  def defaults
    {
      user_ids: User.ids,
      actual_id: TimeRangeType.actual_type.try(:id)
    }
  end

  def admin_x_axis
    (5..10).map do |month|
      Time.zone.local(2020, month, 1).strftime(I18n.t('time.formats.iso8601_utc'))
    end
  end

  def filter_start_date
    return unless @params[:filter_start_year] && @params[:filter_start_month]

    Date.new(@params[:filter_start_year].to_i, @params[:filter_start_month].to_i).beginning_of_month
  end

  def filter_end_date
    return unless @params[:filter_end_year] && @params[:filter_end_month]

    Date.new(@params[:filter_end_year].to_i, @params[:filter_end_month].to_i).end_of_month
  end

  def filter_tag_ids
    @params[:filter_tag_ids]&.split(',')
  end
end
