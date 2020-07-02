class DashboardController < ApplicationController
  def teams
    @presenter = DashboardPresenter.new(params: dashboard_params)

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(
          graphs: [:line_graph]
        )
      end
    end
  end

  def individuals
    @presenter = DashboardPresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(
          graphs: [:bar_chart]
        )
      end
    end
  end

  private

  def dashboard_params
    params.permit(:user_ids, :plan_id, :actual_id)
  end
end
