module SecuredWithOauth
  extend ActiveSupport::Concern

  def user_authenticated?
    session && session[:userinfo].present?
  end

  def authenticate_user!
    if user_authenticated?
      user = User.find_or_initialize_by(email: session[:userinfo]['info']['email'])

      unless user.persisted?
        user.first_name = session.dig(:userinfo, 'extra', 'raw_info', 'given_name')
        user.last_name = session.dig(:userinfo, 'extra', 'raw_info', 'family_name')
        user.save!
      end

      @current_user = user
    else
      redirect_to root_path
    end
  end

  def current_user
    @current_user
  end
  delegate :name, :email, to: :current_user, prefix: :current_user
end
