require 'rubygems'
require 'net/ldap'

# docker run --rm -p 10389:10389 -p 10636:10636 rroemhild/test-openldap
# docker run -it --rm -p 10389:10389 dwimberger/ldap-ad-it

# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/
# ldapsearch -W -h ldap.forumsys.com -D "uid=tesla,dc=example,dc=com" -b "dc=example,dc=com"
# password: password

# bundle exec rails runner lib/ldap_test.rb
# or
# bundle exec ruby lib/ldap_test.rb

class LDAPTest
  # ORGANISATION_UNIT = 'people'.freeze
  # HOST = ENV.fetch('LDAP_HOST')
  # PORT = ENV.fetch('LDAP_PORT')
  # LDAP_BASE = ENV.fetch('LDAP_BASE')

  # , email: nil, cn: nil)
  def self.bind(host:, port:, base:, bind_dn:, password:)
    # ou_query = cn && cn == 'admin' ? nil : "ou=#{ORGANISATION_UNIT},"

    ldap = Net::LDAP.new(
      host: host,
      port: port,
      base: base,
      # encryption: :simple_tls,
      auth: {
        username: bind_dn,
        # username: "cn=#{cn},#{ou_query}#{LDAP_BASE}",
        # username: "uid=#{uid},ou=#{ORGANISATION_UNIT},#{ENV.fetch('LDAP_BASE')}",
        password: password,
        method: :simple
      }
    )

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

ldap = LDAPTest.bind(host: 'ldap.forumsys.com', port: 389, base: 'dc=example,dc=com', bind_dn: 'uid=tesla,dc=example,dc=com', password: 'password')
LDAPTest.filter(ldap, %w[uid tesla])

# cn = 'Philip J. Fry'
# login = 'fry'
# password = 'fry'
# email = 'fry@planetexpress.com'

# ldap = LdapTest.valid_credentials?(cn: cn, password: password)
# res = LdapTest.filter(ldap, %w[sAMAccountName fry])
# pp 'filter res', res

# LdapTest.valid_credentials?(cn: 'admin', password: 'GoodNewsEveryone')

# ldap3 = Net::LDAP.new(
#   host: 'ldap.forumsys.com',
#   port: 389,
#   base: 'dc=example,dc=com',
#   # encryption: :simple_tls,
#   auth: {
#     username: 'uid=tesla,dc=example,dc=com',
#     password: 'password',
#     method: :simple
#   }
# )

# puts ldap3.bind

# search_filter = Net::LDAP::Filter.eq("uid", 'tesla')
# #result_attrs = %w[sAMAccountName displayName mail]
# #result_attrs = %w[mail telephoneNumber]
# ldap3.search(base: 'uid=tesla,dc=example,dc=com', filter: search_filter) { |item|
#   #puts "#{item.sAMAccountName.first}: #{item.displayName.first} (#{item.mail.first})"
#   puts item.to_h.inspect
# }
