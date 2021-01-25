module SecuredWithOauth
  extend ActiveSupport::Concern

  def user_authenticated?
    session && session[:user_id].present?
  end

  def authenticate_user!
    if user_authenticated?
      @current_user = User.find(session[:user_id])
    else
      redirect_to root_path
    end
  end

  def current_user
    @current_user
  end
end
