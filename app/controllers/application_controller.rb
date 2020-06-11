class ApplicationController < ActionController::Base
  include SecuredWithOauth
  protect_from_forgery with: :exception
  helper_method :user_authenticated?
end
