class TeamsController < ApplicationController
  def dashboard
    @presenter = DashboardPresenter.new(params: team_params)
    respond_to do |format|
      format.html
      format.json do
        json = Rails.cache.fetch('teams') do
          @presenter.to_json(graphs: [{ type: :line_graph, data: :team_data, units: '%' }])
        end
        render json: json
      end
    end
  end

  def individuals
    @presenter = DashboardPresenter.new(params: team_params)

    respond_to do |format|
      format.html
      format.json do
        json = Rails.cache.fetch('individuals') do
          @presenter.to_json(graphs: [{ type: :bar_chart, data: :individual_data, units: '%' }])
        end
        render json: json
      end
    end
  end

  private

  def team_params
    params.permit(:format, :page, :user_ids, :plan_id, :actual_id)
  end
end
