class TeamIndividualsController < ApplicationController
  before_action :find_team
  before_action :find_user
  before_action :find_user_groups
  before_action :initialize_presenter

  def show
    respond_to do |format|
      format.html
      format.json do
        dataset_labels = t("graphs.#{params[:graph_kind]}.dataset_labels.#{params[:time_scope] || 'weekly'}", default: nil)
        units = t("graphs.#{params[:graph_kind]}.units", default: '')

        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_individual_data, units: units, dataset_labels: dataset_labels }]
        )
      end
    end
  end

  def data
    @weekly_data = @presenter.time_ranges_weekly_data # TODO: .page(params[:page])
  end

  private

  def find_team
    @user_group_team = UserGroup.find(params[:team_id])
  end

  def find_user
    @user = @user_group_team.users.find(params[:id])
  end

  def find_user_groups
    @user_groups = @user.user_groups.where.not(id: @user_group_team.id)
  end

  def initialize_presenter
    @presenter = TeamIndividualPresenter.new(params: team_individual_params.merge(time_scope: params[:time_scope]))
  end

  def team_individual_params
    params.permit(:team_id, :id, :graph_kind, :time_scope,
                  :filter_tag_ids, :filter_start_month, :filter_start_year, :filter_end_month, :filter_end_year,
                  :page, :format)
  end
end
