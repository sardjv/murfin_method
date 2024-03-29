require 'net/ldap'
require 'devise/strategies/authenticatable'

class Devise::Strategies::LdapAuthenticatable < Devise::Strategies::Authenticatable
  def valid?
    ENV['AUTH_METHOD']&.split(',')&.include?('ldap') && params[:ldap_user].present?
  end

  def authenticate! # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    attrs = {
      host: host,
      port: port,
      base: base,
      auth: {
        username: username,
        password: password,
        method: :simple
      }
    }

    attrs[:encryption] = :simple_tls if encrypted

    Rails.logger.info "LdapAuthenticatable | attrs: #{attrs.inspect}"
    ldap = Net::LDAP.new(attrs)

    if ldap.bind
      Rails.logger.info "LdapAuthenticatable | bound: #{ldap.inspect}"

      filter = Net::LDAP::Filter.eq(bind_key, bind_value)
      result = ldap.search(filter: filter, return_result: true)
      search_result = result[0]
      Rails.logger.info "LdapAuthenticatable | search result: #{search_result.to_h.inspect}"

      user = User.find_using_ldap_bind(bind_value)

      unless user
        email = search_result['mail'][0] if search_result['mail']
        user_attrs = { ldap: { bind_key.to_sym => bind_value }, email: email }.merge(prepare_user_name(search_result)).compact
        Rails.logger.info "LdapAuthenticatable | new user attrs: #{user_attrs.inspect}"
        user = User.create(user_attrs)
      end

      if user.valid?
        success!(user)
      else
        fail!(:ldap_user_fetch)
      end
    else
      Rails.logger.error "LdapAuthenticatable | error: #{ldap.get_operation_result.message}"
      fail!(:ldap_bind) # fail without "!" goes to the next strategy
    end
  end

  private

  def username
    if (bind_key.downcase == 'userprincipalname' || bind_key.downcase == 'samaccountname') && upn_suffix.present?
      "#{bind_value}@#{upn_suffix}"
    else
      "#{bind_key}=#{bind_value},#{base}"
    end
  end

  def host
    ENV.fetch('LDAP_AUTH_HOST')
  end

  def port
    ENV.fetch('LDAP_AUTH_PORT')
  end

  def base
    ENV.fetch('LDAP_AUTH_BASE')
  end

  def bind_key
    ENV.fetch('LDAP_AUTH_BIND_KEY').downcase
  end

  def bind_value
    params[:ldap_user][:uid]
  end

  def upn_suffix
    ENV['LDAP_AUTH_UPN_SUFFIX']
  end

  def password
    params[:ldap_user][:password]
  end

  def encrypted
    ENV['LDAP_AUTH_ENCRYPTED'].try(:as_boolean)
  end

  def prepare_user_name(res)
    if res[:sn].present? && res[:givenname].present?
      { first_name: res[:givenname][0], last_name: res[:sn][0] }
    elsif res[:cn].present?
      arr = res[:cn][0].split
      { first_name: arr[0], last_name: arr[1] }
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
