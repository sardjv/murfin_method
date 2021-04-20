class Admin::PlansController < ApplicationController
  def index
    authorize :plan
    @plans = Plan.includes(:user).order(updated_at: :desc).page(params[:page])
  end
end
