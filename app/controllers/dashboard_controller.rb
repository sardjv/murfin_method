class DashboardController < ApplicationController
  def show
    @presenter = DashboardPresenter.new(params: params)
  end
end
