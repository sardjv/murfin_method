# frozen_string_literal: true

require 'concerns/uses_filters'

class TeamDashboardPresenter
  include UsesFilters

  attr_accessor :context

  def initialize(args)
    @cookies = args[:cookies]
    query = args[:params].delete(:query)
    query_params = prepare_query_params(query)

    @params = defaults
              .merge(args[:params].to_hash.symbolize_keys)
              .merge(query_params)
  end

  # team dashboard boxes

  delegate :average_delivery_percent, to: :team_stats_presenter
  delegate :members_under_delivered_percent, to: :team_stats_presenter

  def user_count
    @user_count ||= users.count
  end

  def users_with_job_plan_count
    users.all.joins(:plans).count('DISTINCT(users.id)')
  end

  # team dashboard line chart

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

  # individuals

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

  def individual_data
    users.map do |user|
      {
        name: user.name,
        value: bar_chart_value(user: user)
      }
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

  def to_json(args)
    args[:graphs].each_with_object({}) do |graph, hash|
      data = send(graph[:data])

      hash[graph[:type]] = {
        data: data,
        units: units,
        dataset_labels: dataset_labels
      }.delete_if { |_k, v| v.blank? }

      (args[:extras] || []).each do |name|
        hash[name] = @team_stats_presenter.send(name)
      end

      hash
    end.to_json
  end

  private

  def users
    @users ||= User.where(id: @params[:user_ids]).order(:last_name, :first_name)
  end

  def defaults
    {
      user_ids: User.ids,
      actual_id: TimeRangeType.actual_type.try(:id)
    }.merge(filters_defaults)
  end

  def dataset_labels
    I18n.t("graphs.#{@params[:graph_kind]}.dataset_labels.#{@params[:time_scope]}", default: nil)
  end

  def units
    I18n.t("graphs.#{@params[:graph_kind]}.units", default: '')
  end

  # team individuals bar chart
  def bar_chart_value(user:)
    return if user.time_ranges.none?

    user_stats_presenter(user).percentage_delivered
  end
end
