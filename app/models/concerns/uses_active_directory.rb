module UsesActiveDirectory
  extend ActiveSupport::Concern

  included do
    # return unless ENV['AUTH_METHOD']&.split(',')&.include?('ldap')

    bind_key = ENV['LDAP_AUTH_BIND_KEY']
    # raise StandardError, 'LDAP_AUTH_BIND_KEY .env setting missing.' if bind_key.blank?

    store :ad_preferences, accessors: ["ad_#{bind_key}".to_sym]
    send(:extend, MixinClassMethods)
  end

  module MixinClassMethods
    def find_by_ldap_bind(bind_value)
      bind_key = ENV.fetch('LDAP_AUTH_BIND_KEY')
      User.where('ad_preferences LIKE ?', "%\nad_#{bind_key}: #{bind_value}\n%").first
    end
  end
end
