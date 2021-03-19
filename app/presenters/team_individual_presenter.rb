# frozen_string_literal: true

require 'concerns/uses_filters'

class TeamIndividualPresenter
  attr_reader :user, :user_group_team, :user_groups

  include UsesFilters

  def initialize(args) # rubocop:disable Metrics/AbcSize
    @cookies = args[:cookies]
    query = args[:params].delete(:query)
    @query_params = prepare_query_params(query)

    @params = defaults
              .merge(args[:params].to_hash.symbolize_keys)
              .merge(query_params)

    @user_group_team = UserGroup.find(@params[:team_id])
    @user = @user_group_team.users.find(@params[:id])
    @user_groups = @user.user_groups.where.not(id: @user_group_team.id)
  end

  def team_individual_data
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

  # used on Team/Individual/Data
  def time_ranges_weekly_data # rubocop:disable Metrics/AbcSize
    weeks_data = {}
    team_stats_presenter.weeks.each do |week_start|
      range = week_start.to_date..week_start.end_of_week.to_date

      planned_minutes = planned_time_ranges.sum do |tr|
        tr.segment_value(segment_start: range.begin.beginning_of_day, segment_end: range.end.end_of_day)
      end

      actual_minutes = actual_time_ranges.sum do |tr|
        tr.segment_value(segment_start: range.begin.beginning_of_day, segment_end: range.end.end_of_day)
      end

      percentage = planned_minutes ? Numeric.percentage_rounded(actual_minutes, planned_minutes) : nil

      weeks_data[range] = { planned_minutes: planned_minutes, actual_minutes: actual_minutes, percentage: percentage }
    end

    weeks_data
  end

  def team_stats_presenter
    @team_stats_presenter ||= TeamStatsPresenter.new(
      user_ids: [@user.id],
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids,
      graph_kind: @params[:graph_kind],
      time_scope: @params[:time_scope]
    )
  end

  def user_stats_presenter
    @user_stats_presenter ||= UserStatsPresenter.new(
      user: @user,
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids
    )
  end

  def to_json(args)
    args[:graphs].each_with_object({}) do |graph, hash|
      hash[graph[:type]] = {
        data: send(graph[:data]),
        units: graph[:units],
        dataset_labels: graph[:dataset_labels]
      }.delete_if { |_k, v| v.blank? }

      hash
    end.to_json
  end

  # Team/Individual/Data (Boxes)
  def average_planned_per_week
    user_stats_presenter.average_weekly_planned
  end

  def average_worked_per_week
    user_stats_presenter.average_weekly_actual
  end

  def average_delivered_percent_per_week
    user_stats_presenter.percentage_delivered
  end
  # EOF Team/Individual/Data (Boxes)

  private

  def planned_time_ranges
    @planned_time_ranges ||= user_stats_presenter.planned_time_ranges
  end

  def actual_time_ranges
    @actual_time_ranges ||= user_stats_presenter.actual_time_ranges
  end

  def defaults
    {
      actual_id: TimeRangeType.actual_type.try(:id)
    }.merge(filters_defaults)
  end
end
