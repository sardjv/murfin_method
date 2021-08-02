module UsesActiveDirectory
  extend ActiveSupport::Concern

  included do
    return unless ENV['AUTH_METHOD']&.split(',')&.include?('ldap')
    bind_key = ENV['LDAP_AUTH_BIND_KEY']
    raise StandardError.new('LDAP_AUTH_BIND_KEY .env setting missing.') unless bind_key.present?
    pp "--------indluded passed", bind_key
    serialize :ad_preferences, accessors: [ "ad_#{bind_key.to_sym}" ]
    #send(:extend, ClassMethods)
  end

  # included do
  #   serialize :ad_preferences
  # end

  module ClassMethods
    def find_by_ldap_bind_key(value)
      key = ENV.fetch 'LDAP_AUTH_BIND_KEY'
      pp "key: #{key}"

      User.where('ad_preferences LIKE ?', "%ad_#{key}='#{value}'%").first
    end
  end

end
