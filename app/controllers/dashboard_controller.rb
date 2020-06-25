class DashboardController < ApplicationController
  def show
    @presenter = DashboardPresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.graph_data.to_json }
    end
  end
end
