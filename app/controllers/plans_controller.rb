class PlansController < ApplicationController
  include Pundit

  def index
    @plans = Plan.where(user_id: @current_user.id).order(updated_at: :desc).page(params[:page])
  end

  def new
    @plan = Plan.new(user: @current_user)
    authorize @plan

    render action: :edit
  end

  def create
    @plan = build_plan
    authorize @plan

    if @plan.save
      redirect_to plans_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit
    end
  end

  def edit
    @plan = Plan.find(params[:id])
    authorize @plan
  end

  def update
    @plan = Plan.find(params[:id])

    if @plan.update(plan_params)
      redirect_to edit_plan_path(@plan), notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path, notice: notice('successfully.destroyed')
  end

  private

  def notice(action)
    t("notice.#{action}", model_name: Plan.model_name.human)
  end

  def build_plan
    Plan.new(plan_params) do |plan|
      plan.end_date = plan.start_date + Plan.default_length
    end
  end

  def plan_params
    params.require(:plan).permit(
      :start_date,
      :end_date,
      :user_id,
      activities_attributes: [
        :id, :seconds_per_week, :_destroy, { tag_associations_attributes: %i[id tag_type_id tag_id _destroy] }
      ],
      signoffs_attributes: %i[id user_id _destroy]
    )
  end
end
