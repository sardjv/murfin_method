class Auth0Controller < ApplicationController
  skip_before_action :authenticate_user!

  def callback
    session[:userinfo] = request.env['omniauth.auth']
    redirect_to user_dashboard_path
  end

  def failure
    flash.notice = request.params['message']
    redirect_to root_path
  end

  def destroy
    reset_session
    flash.notice = 'You have been logged out.'
    redirect_to root_path
  end
end
