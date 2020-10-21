class DashboardController < ApplicationController
  def user
    respond_to do |format|
      format.html
    end
  end

  def admin
    @presenter = DashboardPresenter.new(params: dashboard_params)

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :line_graph, data: :admin_data }])
      end
    end
  end

  def teams
    @presenter = DashboardPresenter.new(params: dashboard_params)
    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :line_graph, data: :team_data, units: '%' }])
      end
    end
  end

  def individuals
    @presenter = DashboardPresenter.new(params: dashboard_params)

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :bar_chart, data: :individual_data, units: '%' }])
      end
    end
  end

  private

  def dashboard_params
    params.permit(:format, :page, :user_ids, :plan_id, :actual_id)
  end
end
