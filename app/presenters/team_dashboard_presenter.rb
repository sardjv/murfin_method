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

  def users_count
    @users_count ||= users.count
  end

  def users_with_job_plan_count
    Plan.where(user_id: user_ids).pluck('DISTINCT(user_id)').count
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

  # team individuals
  def paginated_users
    users.page(@params[:page])
  end

  # used for users table
  def user_stats_presenter(user)
    UserStatsPresenter.new(
      user: user,
      actual_id: TimeRangeType.actual_type.id,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids
    )
  end

  # used for bar chart
  def individual_data # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    plan_ids = Plan.where(user_id: user_ids).pluck(:id)
    activities = Activity.where(plan_id: plan_ids)
    activities = activities.filter_by_tag_types_and_tags(filter_tag_ids) if filter_tag_ids.present?
    activitites_by_user_id = activities.includes(:plan).group_by { |a| a.plan.user_id }

    planned_time_ranges_by_user_id = activitites_by_user_id.transform_values { |aa| aa.flat_map(&:to_bulk_time_range) }
    calculated_planned_time_ranges_by_user_id = planned_time_ranges_by_user_id.transform_values do |trs|
      trs.select do |tr|
        Intersection.call(a_start: tr.start_time, a_end: tr.end_time, b_start: filter_start_time, b_end: filter_end_time).positive?
      end
    end

    total_planned_time_ranges_by_user_id = calculated_planned_time_ranges_by_user_id.transform_values do |trs|
      total_segment_values(trs)
    end

    actual_time_ranges = TimeRange.where(user_id: user_ids)
    actual_time_ranges = actual_time_ranges.filter_by_tag_types_and_tags(filter_tag_ids) if filter_tag_ids.present?

    if filter_start_time && filter_end_time
      actual_time_ranges = actual_time_ranges.where('start_time BETWEEN ? AND ?', filter_start_time, filter_end_time).or(
        actual_time_ranges.where('end_time BETWEEN ? AND ?', filter_start_time, filter_end_time)
      ).or(
        actual_time_ranges.where('start_time <= ? AND end_time >= ?', filter_start_time, filter_end_time)
      ).distinct
    end

    actual_time_ranges_by_user_id = actual_time_ranges.group_by(&:user_id)
    total_actual_time_ranges_by_user_id = actual_time_ranges_by_user_id.transform_values do |trs|
      total_segment_values(trs)
    end

    user_names_map.collect do |id, name|
      {
        name: name,
        value: total_percentage_delivered(total_planned_time_ranges_by_user_id[id], total_actual_time_ranges_by_user_id[id])
      }
    end
  end

  def total_percentage_delivered(total_planned, total_actual)
    return unless total_planned && total_actual

    Numeric.percentage_rounded(total_actual, total_planned)
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

  def to_json(args) # rubocop:disable Metrics/AbcSize
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

  def user_ids
    @user_ids ||= users.pluck(:id)
  end

  def user_names_map
    users.select(:id, :first_name, :last_name).collect { |u| [u.id, u.name] }.to_h
  end

  def total_segment_values(time_ranges)
    time_ranges.sum do |t|
      t.segment_value(
        segment_start: filter_start_time,
        segment_end: filter_end_time
      )
    end
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
end
