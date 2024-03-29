class UsersController < ApplicationController
  include RememberParams

  skip_after_action :verify_authorized
  before_action :initialize_presenter, only: %i[summary data]

  def dashboard; end

  def summary
    respond_to do |format|
      format.html
      format.json do
        dataset_labels = t("graphs.#{graph_kind}.dataset_labels.#{graph_time_scope}", default: nil)
        units = t("graphs.#{graph_kind}.units", default: '')

        render json: @presenter.to_json(
          graphs: [{ type: :line_graph, data: :team_individual_data, units: units, dataset_labels: dataset_labels }]
        )
      end
    end
  end

  def data; end

  private

  def initialize_presenter
    @presenter = TeamIndividualPresenter.new(params: team_individual_params.merge(id: current_user.id,
                                                                                  time_scope: graph_time_scope,
                                                                                  graph_kind: graph_kind))
  end

  def team_individual_params
    params.permit(:team_id, :id, :graph_kind, :time_scope, :page, :format, query: {})
  end
end
