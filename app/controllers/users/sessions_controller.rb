# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %w[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  # before_action :configure_sign_in_params, only: [:create]

  protected

  def after_sign_in_path_for(_resource)
    # session[:auth_method] = request.env['warden'].winning_strategy.class.name.include?('LdapAuthenticatable') ? 'ldap' : 'form'

    current_user.try(:admin) ? admin_dashboard_path : dashboard_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
