class Admin::PlansController < ApplicationController
  def index
    authorize :plan

    respond_to do |format|
      format.html do
        @q = Plan.order(updated_at: :desc).ransack(params[:q])
        @plans = @q.result(distinct: true).includes(:user, activities: :tags).page(params[:page])
      end
      format.csv do # debug only
        send_data CsvExport::Plans.call(plans: Plan.order(updated_at: :desc)), filename: "plans_#{Date.current}.csv"
      end
    end
  end
end
