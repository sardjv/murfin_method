module ResourceUsesLdap
  extend ActiveSupport::Concern

  included do
    if ENV['AUTH_METHOD']&.split(',')&.include?('ldap')
      attribute "ldap_#{ENV['LDAP_AUTH_BIND_KEY'].downcase}".to_sym, if: :uses_ldap?

      send(:extend, MixinClassMethods)
    end
  end

  module ClassMethods
    def uses_ldap?
      ENV['AUTH_METHOD']&.split(',')&.include?('ldap').as_boolean && ENV['LDAP_AUTH_BIND_KEY'].present?
    end
  end

  module MixinClassMethods
    def ldap_auth_bind_key_field
      "ldap_#{ENV['LDAP_AUTH_BIND_KEY'].downcase}".to_sym
    end
  end
end
