class TeamIndividualsController < ApplicationController
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

  def data; end

  private

  def initialize_presenter
    @presenter = TeamIndividualPresenter.new(params: team_individual_params.merge(time_scope: params[:time_scope]))
  end

  def team_individual_params
    params.permit(:team_id, :id, :graph_kind, :time_scope,
                  :filter_tag_ids, :filter_start_month, :filter_start_year, :filter_end_month, :filter_end_year,
                  :page, :format, query: {})
  end
end
