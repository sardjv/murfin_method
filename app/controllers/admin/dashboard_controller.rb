class Admin::DashboardController < ApplicationController
  include RememberParams

  def show
    authorize :dashboard, :admin_dashboard?
  end

  private

  def dashboard_params
    params.permit(:format, :page, :user_ids, :plan_id, :actual_id, :time_scope)
  end
end
