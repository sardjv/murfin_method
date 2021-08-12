class Auth0Controller < ApplicationController
  skip_after_action :verify_authorized
  skip_before_action :authenticate_user!
  include LogoutHelper

  def callback # rubocop:disable Metrics/AbcSize
    user = find_or_create_user_from_auth_info(request.env['omniauth.auth'])
    return redirect_to root_path, alert: I18n.t('notice.login_error') unless user

    session[:auth_method] = 'oauth2'
    session[:user_id] = user.id
    cookies.signed[:user_id] = user.id

    # call method from Devise trackable hook https://github.com/heartcombo/devise/blob/master/lib/devise/models/trackable.rb
    user.update_tracked_fields!(request)

    redirect_to dashboard_path
  end

  def failure
    flash.notice = request.params['message']

    redirect_to root_path
  end

  def destroy
    reset_session
    cookies.delete :user_id

    flash.notice = I18n.t('notice.logged_out')
    redirect_to logout_url.to_s
  end

  private

  def find_or_create_user_from_auth_info(auth_info)
    user = User.find_or_initialize_by(email: auth_info.dig(:info, 'email'))
    return user if user.persisted?

    user.first_name = auth_info.dig(:extra, :raw_info, :given_name)
    user.last_name = auth_info.dig(:extra, :raw_info, :family_name)
    user if user.save
  end
end
