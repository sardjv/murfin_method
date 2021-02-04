class Admin::PlansController < ApplicationController
  def index
    @plans = Plan.includes(:user).order(updated_at: :desc).page(params[:page])
  end
end
