module SecuredWithOauth
  extend ActiveSupport::Concern

  def user_authenticated?
    session && session[:userinfo].present?
  end

  def authenticate_user!
    if user_authenticated?
      @current_user = find_or_create_user
    else
      redirect_to root_path
    end
  end

  def current_user
    @current_user
  end

  private

  def find_or_create_user
    user = User.find_or_initialize_by(email: session.dig(:userinfo, 'info', 'email'))

    unless user.persisted?
      user.first_name = session.dig(:userinfo, 'extra', 'raw_info', 'given_name')
      user.last_name = session.dig(:userinfo, 'extra', 'raw_info', 'family_name')
      user.save!
    end

    user
  end
end
