class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SecuredWithDevise
  include SecuredWithOauth

  before_action :authenticate_user!
  before_action :nav_presenter, except: %w[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

  include Pundit
  include PunditHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, unless: -> { devise_controller? }

  def auth_method_enabled?(method_name)
    # AuthConfig.auth_method_enabled?(method_name)
    AUTH_CONFIG.auth_method_enabled?(method_name)
  end
  helper_method :auth_method_enabled?

  def auth_method_used?(method_name)
    # AuthConfig.auth_method_used?(session, method_name)
    AUTH_CONFIG.auth_method_used?(session, method_name)
  end
  helper_method :auth_method_used?

  def user_authenticated?
    auth_method_enabled?('form') || auth_method_enabled?('ldap') ? user_authenticated_via_devise? : user_authenticated_via_oauth?
  end
  helper_method :user_authenticated?

  helper_method :current_user_name, :current_user_email

  def nav_presenter
    return unless current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: current_user)
  end

  protected

  def authenticate_user!
    auth_method_enabled?('form') || auth_method_enabled?('ldap') ? authenticate_user_via_devise! : authenticate_user_via_oauth!
  end
end
