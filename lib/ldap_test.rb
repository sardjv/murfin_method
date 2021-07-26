# rubocop:disable Metrics/ParameterLists, Rails/Output

require 'rubygems'
require 'net/ldap'

# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/
# ldapsearch -h ldap.forumsys.com -D "uid=tesla,dc=example,dc=com" -b "dc=example,dc=com" -w password -d 65535
# password: password
# ldapwhoami -H ldap://ldap.forumsys.com -x

# bundle exec rails runner lib/ldap_test.rb

class LdapTest
  def self.bind(host:, port:, base:, user_field:, uid:, password:, encrypted: true)
    attrs = {
      host: host,
      port: port,
      base: base,
      auth: {
        username: "#{user_field}=#{uid},#{base}",
        password: password,
        method: :simple
      }
    }

    attrs[:encryption] = :simple_tls if encrypted.as_boolean
    pp 'attrs:', attrs
    ldap = Net::LDAP.new(attrs)

    if ldap.bind
      puts "bind success: #{ldap.get_operation_result.message}"
      ldap
    else
      puts "bind fail: #{ldap.get_operation_result.message}"
    end
  end

  def self.filter(ldap, args)
    filter = Net::LDAP::Filter.eq(*args)
    # result_attrs = %w[sAMAccountName displayName mail]
    # base: base, attributes: attributes: result_attrs ?
    ldap.search(filter: filter, return_result: true)
  end
end

ldap = LdapTest.bind(host: ENV['LDAP_AUTH_HOST'],
                     port: ENV['LDAP_AUTH_PORT'],
                     base: ENV['LDAP_AUTH_BASE'],
                     user_field: ENV['LDAP_AUTH_USER_FIELD'],
                     uid: ENV['LDAP_TEST_UID'],
                     password: ENV['LDAP_TEST_PASSWORD'],
                     encrypted: ENV['LDAP_AUTH_ENCRYPTED'])

pp 'search results:', LdapTest.filter(ldap, [ENV['LDAP_AUTH_USER_FIELD'], ENV['LDAP_TEST_UID']])

# rubocop:enable Metrics/ParameterLists, Rails/Output
