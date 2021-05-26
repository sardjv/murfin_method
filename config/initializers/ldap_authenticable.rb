require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable

      def valid?
        ENV['LDAP_AUTH_ENABLED'].as_boolean && params[:ldap_user].present?
      end

      def authenticate!
        pp 'authenticate!'
        pp 'headers', headers
        if uid.present? || password.present?

          ldap = Net::LDAP.new(
            host: ENV.fetch('LDAP_HOST'),
            port: ENV.fetch('LDAP_PORT'),
            base: ENV.fetch('LDAP_BASE'),
            #encryption: :simple_tls,
            auth: {
              #username: "uid=#{uid},ou=users,#{ENV.fetch('LDAP_BASE')}",
              #username: "cn=Philip J. Fry,ou=people,dc=planetexpress,dc=com", # works
              #username: "uid=#{uid},ou=people,#{ENV.fetch('LDAP_BASE')}",
              username: "cn=Philip J. Fry,ou=people,#{ENV.fetch('LDAP_BASE')}", # works
              password: password,
              method: :simple
            }
          )

          if ldap.bind
            pp 'ldap bound', ldap

            filter = Net::LDAP::Filter.eq('sAMAccountName', uid)
            res = ldap.search(base: ENV.fetch('LDAP_BASE'), filter: filter, return_result: true)
            pp 'search res: ', res

            #user = User.find_or_create_by(email: email)
            email = 'foobar@lorem.pl' # TODO

            user = User.find_by(email: email)

            if user
              success!(user)
            else
              return fail(:ldap_user_not_found_in_database)
            end
          else
            pp 'LDAP error', ldap.get_operation_result.message
            return fail!(:ldap_invalid) # fail without "!" goes to the next strategy
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
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
