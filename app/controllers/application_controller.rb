class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  if ENV['AUTH_METHOD'] == 'oauth2'
    include SecuredWithOauth
  else
    include SecuredWithDevise
  end

  delegate :name, :email, to: :current_user, prefix: :current_user
  helper_method :current_user_name, :current_user_email

  helper_method :user_authenticated?

  before_action :nav_presenter, except: %w[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
  protect_from_forgery with: :exception

  include Pundit
  include PunditHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def nav_presenter
    return unless current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: current_user)
  end
end
