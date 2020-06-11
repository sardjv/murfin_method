module SecuredWithOauth
  extend ActiveSupport::Concern

  def user_authenticated?
    session[:userinfo].present?
  end
end
