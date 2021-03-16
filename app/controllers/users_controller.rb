class UsersController < ApplicationController
  before_action :find_user_group
  before_action :initialize_presenter, only: %i[summary data]

  def summary
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

  def data; end

  private

  def find_user_group
    # assume that user has only one team user group
    @user_group = current_user.user_groups.joins(:group_type).where("group_types.name = 'team'").first
  end

  def initialize_presenter
    @presenter = TeamIndividualPresenter.new(params: team_individual_params.
                                         merge(id: current_user.id, team_id: @user_group.id, time_scope: params[:time_scope]))
  end

  def team_individual_params
    params.permit(:team_id, :id, :graph_kind, :time_scope,
                  :filter_tag_ids, :filter_start_date, :filter_end_date,
                  :page, :format, query: {})
  end
end
