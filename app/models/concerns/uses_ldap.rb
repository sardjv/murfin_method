module UsesLdap
  extend ActiveSupport::Concern

  included do
    #if AuthConfig.auth_method_enabled?('ldap')
    if AUTH_CONFIG.auth_method_enabled?('ldap')
      bind_key = ENV['LDAP_AUTH_BIND_KEY'].downcase
      # raise StandardError, 'LDAP_AUTH_BIND_KEY .env setting missing.' if bind_key.blank?

      store :ldap, prefix: true, accessors: [bind_key.to_sym]
      send(:extend, MixinClassMethods)
    end
  end

  module MixinClassMethods
    def find_using_ldap_bind(bind_value)
      bind_key = AUTH_CONFIG.ldap_auth[:bind_key]
      #bind_key = ENV.fetch('LDAP_AUTH_BIND_KEY')
      User.where('ldap LIKE ?', "%\n#{bind_key.downcase}: #{bind_value}\n%").first
    end
  end
end
