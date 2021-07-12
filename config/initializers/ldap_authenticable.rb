require 'net/ldap'
require 'devise/strategies/authenticatable'

class Devise::Strategies::LdapAuthenticatable < Authenticatable
  ORGANISATION_UNIT = 'people'.freeze

  def valid?
    ENV['LDAP_AUTH_ENABLED'].as_boolean && params[:ldap_user].present?
  end

  def authenticate!
    if uid.present? || password.present?

      ldap = Net::LDAP.new(
        host: ENV.fetch('LDAP_HOST'),
        port: ENV.fetch('LDAP_PORT'),
        base: ENV.fetch('LDAP_BASE'),
        # encryption: :simple_tls,
        auth: {
          # username: "cn=Philip J. Fry,ou=people,dc=planetexpress,dc=com", # works
          # username: "uid=#{uid},ou=people,#{ENV.fetch('LDAP_BASE')}",
          username: "cn=#{uid},ou=#{ORGANISATION_UNIT},#{ENV.fetch('LDAP_BASE')}", # works
          password: password,
          method: :simple
        }
      )

      if ldap.bind
        pp 'ldap bound: ', ldap

        filter = Net::LDAP::Filter.eq('sAMAccountName', uid)
        result_attrs = %w[sAMAccountName displayName mail]

        res = ldap.search(base: ENV.fetch('LDAP_BASE'), filter: filter, attributes: result_attrs, return_result: true)
        user = User.find_by(email: res['mail']) if res.present? && res['mail']

        if user
          success!(user)
        else
          raise(:ldap_user_not_found_in_database)
        end
      else
        pp 'LDAP error', ldap.get_operation_result.message
        fail!(:ldap_invalid) # fail without "!" goes to the next strategy
      end
    end
  end

  def uid
    params[:ldap_user][:uid]
  end

  def password
    params[:ldap_user][:password]
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
