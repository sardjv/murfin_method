class Admin::UsersController < ApplicationController
  before_action :find_and_authorize_user, only: %i[edit update destroy]

  def index
    authorize :user

    @q = User.order(last_name: :asc).ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def new
    @user = User.new
    authorize @user
    render action: :edit
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      redirect_to admin_users_path, notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :edit
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: notice('successfully.destroyed')
    else
      redirect_to admin_users_path, alert: notice('could_not_be.destroyed')
    end
  end

  private

  def find_and_authorize_user
    @user = User.find(params[:id])
    authorize @user
  end

  def notice(action)
    t("notice.#{action}", model_name: User.model_name.human)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :epr_uuid,
      :password,
      :password_confirmation,
      :skip_password_validation,
      :admin,
      user_group_ids: []
    )
  end
end
