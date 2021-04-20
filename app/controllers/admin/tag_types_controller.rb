class Admin::TagTypesController < ApplicationController
  before_action :find_and_authorize_tag_type, only: %i[edit update destroy]

  def index
    authorize :tag_type
    @tag_types = TagType.page(params[:page])
  end

  def new
    @tag_type = TagType.new
    authorize @tag_type
    render action: :edit
  end

  def create
    @tag_type = TagType.new(tag_type_params)
    authorize @tag_type

    if @tag_type.save
      redirect_to admin_tag_types_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit
    end
  end

  def edit; end

  def update
    if @tag_type.update(tag_type_params)
      redirect_to admin_tag_types_path, notice: notice('.successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    if @tag_type.destroy
      redirect_to admin_tag_types_path, notice: notice('successfully.destroyed')
    else
      redirect_to admin_tag_types_path, alert: notice('could_not_be.destroyed')
    end
  end

  private

  def find_and_authorize_tag_type
    @tag_type = TagType.find(params[:id])
    authorize @tag_type
  end

  def notice(action)
    t("notice.#{action}", model_name: TagType.model_name.human)
  end

  def tag_type_params
    params.require(:tag_type).permit(
      :active_for_activities,
      :active_for_time_ranges,
      :name,
      :parent_id
    )
  end
end
