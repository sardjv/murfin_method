require 'net/ldap'
require 'devise/strategies/authenticatable'

class Devise::Strategies::LdapAuthenticatable < Devise::Strategies::Authenticatable
  def valid?
    AuthMethods.ldap? && params[:ldap_user].present?
  end

  def authenticate!
    if uid.present? || password.present?
      attrs = {
        host: ENV.fetch('LDAP_AUTH_HOST'),
        port: ENV.fetch('LDAP_AUTH_PORT'),
        base: ENV.fetch('LDAP_AUTH_BASE'),
        auth: {
          username: "#{ENV.fetch('LDAP_AUTH_USER_FIELD')}=#{uid},#{ENV.fetch('LDAP_AUTH_BASE')}",
          password: password,
          method: :simple
        }
      }

      attrs[:encryption] = :simple_tls if ENV['LDAP_AUTH_ENCRYPTED'].try(:as_boolean)

      ldap = Net::LDAP.new(attrs)

      if ldap.bind
        pp 'ldap bound: ', ldap

        # filter = Net::LDAP::Filter.eq('samaccountname', uid)
        filter = Net::LDAP::Filter.eq(ENV.fetch('LDAP_AUTH_USER_FIELD'), uid)
        # result_attrs = %w[samaccountname displayname mail sn givenname surname]

        # search_result = ldap.search(base: ENV.fetch('LDAP_AUTH_BASE'), filter: filter, return_result: tru, attributes: result_attrs)
        result = ldap.search(filter: filter, return_result: true)
        search_result = result[0]
        pp 'search_result:', search_result

        email = search_result['mail'][0]

        unless user = User.find_by(email: email)
          user_attrs = { email: email }.merge(prepare_name(search_result))
          pp 'user_attrs', user_attrs
          user = User.create(user_attrs)
          pp 'user errors', user.errors
        end

        if user
          session[:user_id] = user.id
          cookies.signed[:user_id] = user.id

          success!(user)
        else
          fail!(:ldap_user_fetch)
        end
      else
        pp 'LDAP error', ldap.get_operation_result.message
        fail!(:ldap_bind) # fail without "!" goes to the next strategy
      end
    end
  end

  private

  def uid
    params[:ldap_user][:uid]
  end

  def password
    params[:ldap_user][:password]
  end

  def prepare_name(res)
    if res[:sn].present? && res[:givenname].present?
      { first_name: res[:givenname][0], last_name: res[:sn][0] }
    elsif res[:cn].present?
      arr = res[:cn][0].split
      { first_name: arr[0], last_name: arr[1] }
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
