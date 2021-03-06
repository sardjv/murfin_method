class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SecuredWithDevise
  include SecuredWithOauth

  before_action :authenticate_user!

  def auth_method?(method_name)
    ENV['AUTH_METHOD'] == method_name.to_s
  end
  helper_method :auth_method?

  def user_authenticated?
    auth_method?('form') ? user_authenticated_via_devise? : user_authenticated_via_oauth?
  end
  helper_method :user_authenticated?

  helper_method :current_user_name, :current_user_email

  before_action :nav_presenter, except: %w[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

  include Pundit
  include PunditHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def nav_presenter
    return unless current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: current_user)
  end

  protected

  def authenticate_user!
    auth_method?('form') ? authenticate_user_via_devise! : authenticate_user_via_oauth!
  end
end
