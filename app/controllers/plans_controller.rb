class PlansController < ApplicationController
  def index
    @plans = Plan.where(user_id: @current_user.id).order(updated_at: :desc).page(params[:page])
  end

  def new
    @plan = Plan.new
    render action: :edit
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user_id = @current_user.id
    if @plan.save
      redirect_to plans_path, notice: t('plan.notice.successfully.created')
    else
      flash.now.alert = t('plan.notice.could_not_be.created')
      render :edit
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])

    if @plan.update(plan_params)
      redirect_to plans_path, notice: t('plan.notice.successfully.updated')
    else
      flash.now.alert = t('plan.notice.could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path, notice: t('plan.notice.successfully.destroyed')
  end

  private

  def plan_params
    params.require(:plan).permit(
      :start_time,
      :end_time,
      :user_id
    )
  end
end
