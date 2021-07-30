# rubocop:disable Rails/Output

require 'rubygems'
require 'net/ldap'

# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/
# ldapsearch -h ldap.forumsys.com -D "uid=tesla,dc=example,dc=com" -b "dc=example,dc=com" -w password -d 1
# password: password
# ldapwhoami -H ldap://ldap.forumsys.com -x

# bundle exec rails runner lib/ldap_test.rb

class LdapTest
  def self.bind # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    host = ENV['LDAP_AUTH_HOST']
    port = ENV['LDAP_AUTH_PORT']
    base = ENV['LDAP_AUTH_BASE']
    bind_key = ENV['LDAP_AUTH_BIND_KEY']
    bind_value = ENV['LDAP_AUTH_BIND_VALUE']
    upx_suffix = ENV['LDAP_AUTH_UPN_SUFFIX'] # upn prefix is taken from bind value
    password = ENV['LDAP_AUTH_PASSWORD']
    encrypted = ENV['LDAP_AUTH_ENCRYPTED']

    username = if bind_key == 'userPrincipalName' && upx_suffix.present?
                 "#{bind_value}@#{upn_suffix}"
               else
                 "#{bind_key}=#{bind_value},#{base}"
               end

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

    attrs[:encryption] = :simple_tls if encrypted.as_boolean
    pp 'LDAP attrs:', attrs
    ldap = Net::LDAP.new(attrs)

    if ldap.bind
      puts "LDAP bind success: #{ldap.get_operation_result.message}"
      ldap
    else
      puts "LDAP bind fail: #{ldap.get_operation_result.message}"
    end
  end

  def self.filter(ldap, args)
    filter = Net::LDAP::Filter.eq(*args)
    # result_attrs = %w[sAMAccountName displayName mail]
    # base: base, attributes: attributes: result_attrs
    ldap.search(filter: filter, return_result: true)
  end
end

ldap = LdapTest.bind

pp 'LDAP search results:', LdapTest.filter(ldap, ['sAMAccountName', ENV['LDAP_AUTH_BIND_VALUE']])

# rubocop:enable Rails/Output
