class TeamIndividualPresenter
  def initialize(args)
    @params = defaults.merge(args[:params].to_hash.symbolize_keys)
    @team = UserGroup.find(@params[:team_id])
    @user = @team.users.find(@params[:id])
  end

  def team_individual_data
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

  def team_individual_table_data
    team_stats_presenter.actual_time_ranges.order(updated_at: :desc).page(@params[:page])
  end

  def team_stats_presenter
    @team_stats_presenter ||= TeamStatsPresenter.new(
      user_ids: [@user.id],
      actual_id: @params[:actual_id],
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: @params[:filter_tag_ids],
      graph_kind: @params[:graph_kind]
    )
  end

  def user_stats_presenter
    @user_stats_presenter ||= UserStatsPresenter.new(
      user: @user,
      actual_id: @params[:actual_id],
      filter_start_date: @params[:filter_start_date],
      filter_end_date: @params[:filter_end_date]
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

  def total_planned
    @total_planned ||= user_stats_presenter.total(user_stats_presenter.planned_time_ranges)
  end

  def total_worked
    @total_worked ||= user_stats_presenter.total(user_stats_presenter.actual_time_ranges(@params[:actual_id]))
  end

  def filter_start_date
    @params[:filter_start_date]
  end

  def filter_end_date
    @params[:filter_end_date]
  end

  private

  def defaults
    {
      actual_id: TimeRangeType.actual_type.try(:id),
      filter_start_date: 1.year.ago.to_date,
      filter_end_date: Time.zone.today,
      filter_tag_ids: Tag.where(default_for_filter: true).pluck(:id)
    }
  end

  # def filter_tag_ids
  #   @params[:filter_tag_ids]&.split(',')
  # end
end
