class DashboardController < ApplicationController
  def admin
    @presenter = DashboardPresenter.new(params: dashboard_params)

    respond_to do |format|
      format.html
      format.json do
        json = Rails.cache.fetch('admin') do
          @presenter.to_json(graphs: [{ type: :line_graph, data: :admin_data }])
        end
        render json: json
      end
    end
  end

  def teams
    @presenter = DashboardPresenter.new(params: dashboard_params)
    respond_to do |format|
      format.html
      format.json do
        json = @presenter.to_json(graphs: [{ type: :line_graph, data: :team_data, units: '%' }])
        render json: json
      end
    end
  end

  def individuals
    @presenter = DashboardPresenter.new(params: dashboard_params)

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

  def dashboard_params
    params.permit(:format, :page, :user_ids, :plan_id, :actual_id)
  end
end
