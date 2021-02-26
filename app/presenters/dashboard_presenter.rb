require 'concerns/uses_filters'

class DashboardPresenter
  include UsesFilters

  def initialize(args)
    query = args[:params].delete(:query)
    query_params = prepare_query_params(query)

    @params = defaults
              .merge(args[:params].to_hash.symbolize_keys)
              .merge(query_params)

    # pp '--------------- params  DashboardPresenter ', @params
  end

  def paginated_users
    users.page(@params[:page])
  end

  def user_stats_presenter(user)
    UserStatsPresenter.new(
      user: user,
      actual_id: TimeRangeType.actual_type.id,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids
    )
  end

  def users_with_job_plan_count
    users.all.joins(:plans).count('DISTINCT(users.id)')
  end

  def individual_data
    users.map do |user|
      {
        'name': user.name,
        'value': bar_chart_value(user: user)
      }
    end
  end

  def team_data
    case @params[:graph_kind]
    when 'planned_vs_actual'
      if @params[:time_scope] == 'weekly'
        [team_stats_presenter.average_weekly_planned_per_week, team_stats_presenter.average_weekly_actual_per_week]
      else
        [team_stats_presenter.average_weekly_planned_per_month, team_stats_presenter.average_weekly_actual_per_month]
      end
    else
      if @params[:time_scope] == 'weekly'
        [team_stats_presenter.weekly_percentage_delivered_per_week]
      else
        [team_stats_presenter.weekly_percentage_delivered_per_month]
      end
    end
  end

  def team_stats_presenter
    @team_stats_presenter ||= TeamStatsPresenter.new(
      user_ids: @params[:user_ids],
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids,
      graph_kind: @params[:graph_kind],
      time_scope: @params[:time_scope]
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

      (args[:extras] || []).each do |name|
        hash[name] = @team_stats_presenter.send(name)
      end

      hash
    end.to_json
  end

  private

  def users
    @users ||= User.where(id: @params[:user_ids])
  end

  def bar_chart_value(user:)
    return if user.time_ranges.none?

    user_stats_presenter(user).percentage_delivered
  end

  def defaults
    {
      user_ids: User.ids,
      actual_id: TimeRangeType.actual_type.try(:id)
    }.merge(filters_defaults)
  end

  def admin_x_axis
    (5..10).map do |month|
      Time.zone.local(2020, month, 1).strftime(I18n.t('time.formats.iso8601_utc'))
    end
  end
end
