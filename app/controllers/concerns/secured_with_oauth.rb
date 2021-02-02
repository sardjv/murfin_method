module SecuredWithOauth
  extend ActiveSupport::Concern

  private

  def user_authenticated_via_oauth?
    session && session[:user_id].present?
  end

  def authenticate_user_via_oauth!
    if user_authenticated?
      @current_user = User.find(session[:user_id])
    else
      redirect_to root_path
    end
  end
end
