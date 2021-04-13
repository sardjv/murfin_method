class Admin::UserGroupsController < ApplicationController
  before_action :find_and_authorize_user_group, only: %i[edit update destroy]

  def index
    authorize :user_group
    @user_groups = UserGroup.page(params[:page])
  end

  def new
    @group_type = GroupType.find(params[:group_type_id])
    @user_group = UserGroup.new
    authorize @user_group
  end

  def create
    @group_type = GroupType.find(params[:group_type_id])
    @user_group = @group_type.user_groups.new(user_group_params)
    authorize @user_group
    if @user_group.save
      redirect_to admin_group_types_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :new
    end
  end

  def edit; end

  def update
    if @user_group.update(user_group_params)
      redirect_to admin_group_types_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    @user_group.destroy
    redirect_to admin_group_types_path, notice: notice('successfully.destroyed')
  end

  private

  def find_and_authorize_user_group
    @user_group = UserGroup.find(params[:id])
    authorize @user_group
  end

  def notice(action)
    t("notice.#{action}", model_name: UserGroup.model_name.human)
  end

  def user_group_params
    params.require(:user_group).permit(
      :name,
      :group_type_id,
      memberships_attributes: %i[role id]
    )
  end
end
