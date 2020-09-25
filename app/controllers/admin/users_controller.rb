module Admin
  class UsersController < ApplicationController
    def index
      @users = User.order(last_name: :asc).page(params[:page])
    end

    def new
      @user = User.new
      render action: :edit
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: t('users.notice.successfully.created')
      else
        flash.now.alert = t('users.notice.could_not_be.created')
        render :edit
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        redirect_to admin_users_path, notice: t('users.notice.successfully.updated')
      else
        flash.now.alert = t('users.notice.could_not_be.updated')
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: t('users.notice.successfully.destroyed')
    end

    private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :admin
      )
    end
  end
end
