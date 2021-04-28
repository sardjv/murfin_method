class Admin::PlansController < ApplicationController
  def index
    authorize :plan

    @q = Plan.order(updated_at: :desc).ransack(params[:q])
    @plans = @q.result(distinct: true).includes(:user, activities: :tags).page(params[:page])
  end
end
