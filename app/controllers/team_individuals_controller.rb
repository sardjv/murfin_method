class TeamIndividualsController < ApplicationController
  before_action :find_user_group
  before_action :find_user
  before_action :initialize_presenter

  def show
    respond_to do |format|
      format.html
      format.json do
        dataset_labels = t("graphs.#{params[:graph_kind]}.dataset_labels", default: nil)
        units = t("graphs.#{params[:graph_kind]}.units", default: '')

        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_individual_data, units: units, dataset_labels: dataset_labels }]
        )
      end
    end
  end

  def data
    @time_ranges = @presenter.team_individual_table_data
  end

  private

  def find_user_group
    @user_group = UserGroup.find(params[:team_id])
  end

  def find_user
    @user = @user_group.users.find(params[:id])
  end

  def initialize_presenter
    @presenter = TeamIndividualPresenter.new(params: team_individual_params)
  end

  def team_individual_params
    params.permit(:team_id, :id, :graph_kind, :filter_start_month, :filter_start_year, :filter_end_month, :filter_end_year, :page, :format)
  end
end
