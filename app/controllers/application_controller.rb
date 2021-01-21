class ApplicationController < ActionController::Base
  if ENV['AUTH_METHOD'] == 'form'
    include SecuredWithDevise
  elsif ENV['AUTH_METHOD'] == 'oauth2'
    include SecuredWithOauth
  end

  before_action :authenticate_user!

  helper_method :user_authenticated?, :current_user_name, :current_user_email

  before_action :nav_presenter, except: %w[create update destroy]
  protect_from_forgery with: :exception

  include Pundit
  include PunditHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def nav_presenter
    return unless current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: current_user)
  end
end
