require 'rubygems'
require 'net/ldap'

# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/
# ldapsearch -h ldap.forumsys.com -D "uid=tesla,dc=example,dc=com" -b "dc=example,dc=com" -w password -d 65535
# password: password
# ldapwhoami -H ldap://ldap.forumsys.com -x

# bundle exec rails runner lib/ldap_test.rb

class LdapTest
  def self.bind(host:, port:, base:, bind_dn:, password:, encrypted: true)
    attrs = {
      host: host,
      port: port,
      base: base,
      auth: {
        username: bind_dn,
        password: password,
        method: :simple
      }
    }

    attrs[:encryption] = :simple_tls if encrypted.as_boolean
    ldap = Net::LDAP.new(attrs)

    puts "\r\n"

    if ldap.bind
      # puts "\r\nbind success: #{cn || uid || email}"
      puts "bind success: #{ldap.get_operation_result.message}"
      ldap
    else
      puts "bind fail: #{ldap.get_operation_result.message}"
    end
  end

  def self.filter(ldap, args)
    filter = Net::LDAP::Filter.eq(*args)
    # result_attrs = %w[sAMAccountName displayName mail]
    # ldap.search(base: LDAP_BASE, filter: filter, attributes: result_attrs, return_result: true)
    puts 'search results:'
    ldap.search(filter: filter, return_result: true) do |item|
      # ldap.search(base: base, filter: filters, return_result: true) do |item|
      pp item.to_h
    end
  end
end

ldap = LdapTest.bind(host: ENV['LDAP_TEST_HOST'],
                     port: ENV['LDAP_TEST_PORT'],
                     base: ENV['LDAP_TEST_BASE'],
                     bind_dn: ENV['LDAP_TEST_BIND_DN'],
                     password: ENV['LDAP_TEST_PASSWORD'],
                     encrypted: ENV['LDAP_TEST_ENCRYPTED'])

# LdapTest.filter(ldap, %w[cn TODO])

LdapTest.filter(ldap, %w[uid tesla])

# ldap = LdapTest.bind(host: 'ldap.forumsys.com',
#    port: 389,
#    base: 'dc=example,dc=com',
#    bind_dn: 'uid=tesla,dc=example,dc=com',
#    password: 'password')

# LdapTest.filter(ldap, %w[uid tesla])
