class ApplicationController < ActionController::Base
  include SecuredWithOauth
  before_action :authenticate_user!
  before_action :nav_presenter, except: %w[create update destroy]
  protect_from_forgery with: :exception
  helper_method :user_authenticated?, :current_user_name, :current_user_email

  def nav_presenter
    return unless @current_user

    @nav_presenter ||= NavPresenter.new(params: params, current_user: @current_user)
  end
end
