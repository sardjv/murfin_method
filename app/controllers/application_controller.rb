class ApplicationController < ActionController::Base
  include SecuredWithOauth
  before_action :authenticate_user!
  before_action :nav_presenter, except: %w[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
  protect_from_forgery with: :exception
  helper_method :user_authenticated?, :current_user_name, :current_user_email

  include Pundit
  include PunditHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def nav_presenter
    return unless @current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: @current_user)
  end
end
