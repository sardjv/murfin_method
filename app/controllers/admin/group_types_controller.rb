class Admin::GroupTypesController < ApplicationController
  def index
    @group_types = GroupType.page(params[:page])
  end

  def new
    @group_type = GroupType.new
    render action: :edit
  end

  def create
    @group_type = GroupType.new(group_type_params)
    if @group_type.save
      redirect_to admin_group_types_path, notice: t('group_types.notice.successfully.created')
    else
      flash.now.alert = t('group_types.notice.could_not_be.created')
      render :edit
    end
  end

  def edit
    @group_type = GroupType.find(params[:id])
  end

  def update
    @group_type = GroupType.find(params[:id])

    if @group_type.update(group_type_params)
      redirect_to admin_group_types_path, notice: t('group_types.notice.successfully.updated')
    else
      flash.now.alert = t('group_types.notice.could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @group_type = GroupType.find(params[:id])
    @group_type.destroy
    redirect_to admin_group_types_path, notice: t('group_types.notice.successfully.destroyed')
  end

  private

  def group_type_params
    params.require(:group_type).permit(
      :name
    )
  end
end
