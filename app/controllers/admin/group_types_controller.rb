class Admin::GroupTypesController < ApplicationController
  before_action :find_and_authorize_group_type, only: %i[edit update destroy]

  def index
    authorize :group_type
    @group_types = GroupType.page(params[:page])
  end

  def new
    @group_type = GroupType.new
    authorize @group_type
    render action: :edit
  end

  def create
    @group_type = GroupType.new(group_type_params)
    authorize @group_type
    if @group_type.save
      redirect_to admin_group_types_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit
    end
  end

  def edit; end

  def update
    if @group_type.update(group_type_params)
      redirect_to admin_group_types_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @group_type.destroy
    redirect_to admin_group_types_path, notice: notice('successfully.destroyed')
  end

  private

  def find_and_authorize_group_type
    @group_type = GroupType.find(params[:id])
    authorize @group_type
  end

  def notice(action)
    t("notice.#{action}", model_name: GroupType.model_name.human)
  end

  def group_type_params
    params.require(:group_type).permit(
      :name
    )
  end
end
