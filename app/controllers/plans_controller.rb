class PlansController < ApplicationController
  include RenderPdf
  before_action :find_and_authorize_plan, only: %i[edit update destroy download]

  def index
    authorize :plan
    @plans = policy_scope(Plan).order(updated_at: :desc).page(params[:page])
  end

  def new
    @plan = Plan.new(user: current_user)
    authorize @plan

    render action: :edit
  end

  def create
    @plan = Plan.new(plan_params)
    authorize @plan

    if @plan.save
      redirect_to edit_plan_path(@plan), notice: notice('successfully.created')
    else
      copy_errors_for_contracted_minutes_per_week
      flash.now.alert = notice('could_not_be.created')
      render :edit, status: :unprocessable_entity
    end
  end

  include PlanHelper

  def download
    respond_to do |format|
      format.html do
        render_attachment(plan_pdf_filename(@plan)) if pdf? && !params.key?(:layout)
      end
    end
  end

  def edit
    @activities = @plan.activities.includes(tags: :children)
    @activity_tags_top_level = @activities.collect do |a|
      a.tags.where(parent_id: nil).with_tag_type_active_for(Activity)
    end.flatten.uniq.sort_by(&:tag_type_id)
  end

  def update
    if @plan.update(plan_params)
      redirect_to edit_plan_path(@plan), notice: notice('successfully.updated')
    else
      copy_errors_for_contracted_minutes_per_week
      flash.now.alert = notice('could_not_be.updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: notice('successfully.destroyed')
  end

  private

  def find_and_authorize_plan
    @plan = Plan.find(params[:id])
    authorize @plan
  end

  def notice(action)
    t("notice.#{action}", model_name: Plan.model_name.human)
  end

  def plan_params
    params.require(:plan).permit(
      :start_date,
      :end_date,
      :user_id,
      :contracted_seconds_per_week,
      activities_attributes: [
        :id, :seconds_per_week, :_destroy, { tag_associations_attributes: %i[id tag_type_id tag_id _destroy] }
      ],
      signoffs_attributes: %i[id user_id _destroy]
    )
  end

  # make display error on the form for respective field
  # we use contracted_minutes_per_week there because of time duration lib
  def copy_errors_for_contracted_minutes_per_week
    return if @plan.errors.messages_for(:contracted_mintes_per_week).empty?

    @plan.errors.add :contracted_seconds_per_week, @plan.errors.messages_for(:contracted_minutes_per_week)
  end
end
