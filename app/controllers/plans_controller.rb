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
    @plan.end_date = @plan.start_date + Plan.default_length
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
      flash.now.notice = t('plan.notice.successfully.updated')
    else
      flash.now.alert = t('plan.notice.could_not_be.updated')
    end

    render :edit
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path, notice: t('plan.notice.successfully.destroyed')
  end

  private

  def plan_params
    params.require(:plan).permit(
      :start_date,
      :end_date,
      :user_id,
      activities_attributes: %i[id schedule _destroy]
    )
  end
end
