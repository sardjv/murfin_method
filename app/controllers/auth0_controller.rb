class Auth0Controller < ApplicationController
  skip_before_action :authenticate_user!
  include LogoutHelper

  def callback
    user_id = find_or_create_user_from_auth_info(request.env['omniauth.auth'])
    return redirect_to root_path, alert: I18n.t('notice.login_error') unless user_id

    session[:user_id] = user_id
    redirect_to dashboard_path
  end

  def failure
    flash.notice = request.params['message']
    redirect_to root_path
  end

  def destroy
    reset_session
    flash.notice = I18n.t('notice.logged_out')
    redirect_to logout_url.to_s
  end

  private

  def find_or_create_user_from_auth_info(auth_info)
    user = User.find_or_initialize_by(email: auth_info.dig(:info, 'email'))
    return user.id if user.persisted?

    user.first_name = auth_info.dig(:extra, :raw_info, :given_name)
    user.last_name = auth_info.dig(:extra, :raw_info, :family_name)
    user.id if user.save
  end
end
