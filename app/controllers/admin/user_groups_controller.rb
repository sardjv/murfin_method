module Admin
  class UserGroupsController < ApplicationController
    def index
      @user_groups = UserGroup.page(params[:page])
    end

    def new
      @group_type = GroupType.find(params[:group_type_id])
      @user_group = UserGroup.new
    end

    def create
      @group_type = GroupType.find(params[:group_type_id])
      @user_group = @group_type.user_groups.new(user_group_params)
      if @user_group.save
        redirect_to admin_group_types_path, notice: t('user_groups.notice.successfully.created')
      else
        flash.now.alert = t('user_groups.notice.could_not_be.created')
        render :new
      end
    end

    def edit
      @user_group = UserGroup.find(params[:id])
    end

    def update
      @user_group = UserGroup.find(params[:id])

      if @user_group.update(user_group_params)
        redirect_to admin_group_types_path, notice: t('user_groups.notice.successfully.updated')
      else
        flash.now.alert = t('user_groups.notice.could_not_be.updated')
        render :edit
      end
    end

    def destroy
      @user_group = UserGroup.find(params[:id])
      @user_group.destroy
      redirect_to admin_group_types_path, notice: t('user_groups.notice.successfully.destroyed')
    end

    private

    def user_group_params
      params.require(:user_group).permit(
        :name,
        :group_type_id,
        memberships_attributes: %i[role id]
      )
    end
  end
end
