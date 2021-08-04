module ResourceUsesLdap
  extend ActiveSupport::Concern

  included do
    #if AuthConfig.auth_method_enabled?('ldap')
    pp 'before: ', AUTH_CONFIG.auth_method_enabled?('ldap')
    if AUTH_CONFIG.auth_method_enabled?('ldap') && AUTH_CONFIG.ldap_auth[:bind_key].present?
      pp '------------------innnn'
      attribute "ldap_#{AUTH_CONFIG.ldap_auth[:bind_key].downcase}".to_sym#, if: :uses_ldap?

      # send(:extend, MixinClassMethods)
    end
  end

  # module ClassMethods
  #   def uses_ldap?
  #     AuthConfig.auth_method_enabled?('ldap') && ENV['LDAP_AUTH_BIND_KEY'].present?
  #   end
  # end

  # module MixinClassMethods
  #   def ldap_auth_bind_key_field
  #     "ldap_#{ENV['LDAP_AUTH_BIND_KEY'].downcase}".to_sym
  #   end
  # end
end
