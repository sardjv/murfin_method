class DashboardController < ApplicationController
  def teams; end

  def individuals
    @presenter = DashboardPresenter.new(params: params)

    respond_to do |format|
      format.html
      format.json { render json: @presenter.to_json }
    end
  end
end
