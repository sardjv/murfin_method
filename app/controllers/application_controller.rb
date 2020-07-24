class ApplicationController < ActionController::Base
  include SecuredWithOauth
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  helper_method :user_authenticated?, :current_user_name, :current_user_email
end
