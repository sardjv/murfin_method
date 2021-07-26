require 'net/ldap'
require 'devise/strategies/authenticatable'

class Devise::Strategies::LdapAuthenticatable < Devise::Strategies::Authenticatable
  def valid?
    ENV['AUTH_METHOD']&.split(',').include?('ldap') && params[:ldap_user].present?
  end

  def authenticate! # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
      Rails.logger.info "LdapAuthenticatable | bound: #{ldap.inspect}"

      # filter = Net::LDAP::Filter.eq('samaccountname', uid)
      filter = Net::LDAP::Filter.eq(ENV.fetch('LDAP_AUTH_USER_FIELD'), uid)
      # result_attrs = %w[samaccountname displayname mail sn givenname surname]

      # search_result = ldap.search(base: ENV.fetch('LDAP_AUTH_BASE'), filter: filter, return_result: tru, attributes: result_attrs)
      result = ldap.search(filter: filter, return_result: true)
      search_result = result[0]
      Rails.logger.info "LdapAuthenticatable | search_result: #{search_result.to_h.inspect}"

      email = search_result['mail'][0]
      user = User.find_by(email: email)

      unless user
        user_attrs = { email: email }.merge(prepare_name(search_result))
        user = User.create(user_attrs)
      end

      if user
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
