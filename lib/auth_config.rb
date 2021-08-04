require 'singleton'

class AuthConfig
  include Singleton

  attr_accessor :auth_methods_enabled, :ldap_auth

  def initialize
    @auth_methods_enabled = ENV['AUTH_METHOD'].present? ? ENV['AUTH_METHOD'].split(',') : []
    @ldap_auth = { bind_key: ENV['LDAP_AUTH_BIND_KEY']&.downcase } if self.auth_method_enabled?('ldap')
  end

  def auth_method_enabled?(method_name)
    @auth_methods_enabled.include?(method_name.to_s)
  end

  def auth_method_used?(session, method_name)
    session[:auth_method] == method_name.to_s
  end

  def ldap_auth_bind_key_field
    return unless self.ldap_auth

    "ldap_#{self.ldap_auth[:bind_key].downcase}".to_sym if self.ldap_auth[:bind_key]
  end
end
