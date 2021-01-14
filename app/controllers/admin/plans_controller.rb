class Admin::PlansController < ApplicationController
  def index
    @plans = Plan.order(updated_at: :desc).page(params[:page])
  end
end
