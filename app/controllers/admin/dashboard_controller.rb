class Admin::DashboardController < ApplicationController
  include RememberParams

  def show
    authorize :dashboard, :admin_dashboard?
    @presenter = DashboardPresenter.new(params: dashboard_params)

    respond_to do |format|
      format.html
      format.json do
        render json: @presenter.to_json(graphs: [{ type: :line_graph, data: :admin_data }])
      end
    end
  end

  private

  def dashboard_params
    params.permit(:format, :page, :user_ids, :plan_id, :actual_id, :time_scope)
  end
end
