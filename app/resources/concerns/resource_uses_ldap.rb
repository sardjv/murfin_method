module ResourceUsesLdap
  extend ActiveSupport::Concern

  included do
    #if AuthConfig.auth_method_enabled?('ldap')
    if AUTH_CONFIG.auth_method_enabled?('ldap')
      attribute "ldap_#{ENV['LDAP_AUTH_BIND_KEY'].downcase}".to_sym, if: :uses_ldap?

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
