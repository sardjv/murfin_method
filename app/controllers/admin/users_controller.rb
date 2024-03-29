class Admin::UsersController < ApplicationController
  before_action :find_and_authorize_user, only: %i[edit update destroy]

  def index
    authorize :user

    respond_to do |format|
      format.html do
        @q = User.order(last_name: :asc).ransack(params[:q])
        @users = @q.result(distinct: true).page(params[:page])
      end
      format.csv do # debug only
        send_data CsvExport::Users.call(users: User.order(last_name: :asc)), filename: "users_#{Date.current}.csv"
      end
    end
  end

  include CableReady::Broadcaster

  def generate_csv
    authorize :user, :download?

    FlashMessageBroadcastJob.perform_now(
      current_user_id: current_user.id,
      message: t('download.queued', records_type: 'users', file_type: 'CSV'),
      extra_data: { message_type: 'download' }
    )

    GenerateUsersCsvJob.perform_later(current_user_id: current_user.id)

    head :no_content
  end

  def download
    authorize :user

    respond_to do |format|
      format.csv do
        redis_key = "users_#{Date.current}_#{current_user.id}.csv"
        csv_data = REDIS_CLIENT.get(redis_key)

        if csv_data
          csv_filename = "users_#{Date.current}.csv"
          send_data csv_data, filename: csv_filename, type: 'text/csv', disposition: 'attachment'

          REDIS_CLIENT.del(redis_key)
        else
          FlashMessageBroadcastJob.perform_now(
            current_user_id: current_user.id,
            message: I18n.t('download.errors.not_found', records_type: 'users', file_type: 'CSV'),
            alert_type: 'danger',
            extra_data: { message_type: 'download' }
          )
        end
      end
    end
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
      render :edit, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: notice('successfully.updated')
    else
      flash.now.alert = notice('could_not_be.updated')
      render :edit, status: :unprocessable_entity
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
