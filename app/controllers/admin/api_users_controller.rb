class Admin::ApiUsersController < ApplicationController
  before_action :find_api_user, only: %i[show generate_token destroy]

  def index
    @api_users = ApiUser.order(created_at: :asc).page(params[:page])
  end

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.new(api_user_params.merge(created_by: current_user.name))

    if @api_user.save
      redirect_to admin_api_user_path(@api_user), notice: notice('successfully.created')
    else
      flash.now.alert = notice('could_not_be.created')
      render :new
    end
  end

  def show; end

  def generate_token
    timestamp = Time.current
    token = generate_api_user_token(timestamp)
    if token && @api_user.update({ token_sample: token.last(5),
                                   token_generated_at: timestamp,
                                   token_generated_by: current_user.name })
      redirect_to admin_api_user_path(@api_user),
                  notice: "#{I18n.t('api_users.token_notice', name: @api_user.name)} #{token}"
    else
      flash.now.alert = t('notice.could_not_be.generated', attribute_name: ApiUser.human_attribute_name('api_token'))
      render :show
    end
  end

  def destroy
    if @api_user.destroy
      redirect_to admin_api_users_path, notice: notice('successfully.destroyed')
    else
      redirect_to admin_api_users_path, alert: notice('could_not_be.destroyed')
    end
  end

  private

  def find_api_user
    @api_user = ApiUser.find(params[:id])
  end

  def notice(action)
    t("notice.#{action}", model_name: ApiUser.model_name.human)
  end

  def api_user_params
    params.require(:api_user).permit(:name, :contact_email)
  end

  def generate_api_user_token(timestamp)
    payload = { data: @api_user.id, timestamp: timestamp }
    jwt_secret = ENV['JWT_SECRET']
    return unless jwt_secret

    JWT.encode(payload, jwt_secret, ENV['JWT_ALGORITHM'])
  end
end
