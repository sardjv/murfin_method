require 'rubygems'
require 'net/ldap'

# docker run --rm -p 10389:10389 -p 10636:10636 rroemhild/test-openldap
# docker run -it --rm -p 10389:10389 dwimberger/ldap-ad-it

class ActiveDirectoryTest
  ORGANISATION_UNIT = 'people'.freeze

  def self.valid_credentials?(password:, uid: nil, email: nil, cn: nil)
    ou_query = cn && cn == 'admin' ? nil : "ou=#{ORGANISATION_UNIT},"

    ldap = Net::LDAP.new(
      host: ENV.fetch('LDAP_HOST'),
      port: ENV.fetch('LDAP_PORT'),
      base: ENV.fetch('LDAP_BASE'),
      # encryption: :simple_tls,
      auth: {
        username: "cn=#{cn},#{ou_query}#{ENV.fetch('LDAP_BASE')}",
        # username: "uid=#{uid},ou=#{ORGANISATION_UNIT},#{ENV.fetch('LDAP_BASE')}",
        password: password,
        method: :simple
      }
    )

    if ldap.bind
      puts "bind success: #{cn || uid || email}"

      ldap
    else
      puts "bind fail: #{ldap.get_operation_result.message}"
    end
  end

  def self.filter(ldap, args)
    filter = Net::LDAP::Filter.eq(*args)
    result_attrs = %w[sAMAccountName displayName mail]
    ldap.search(base: ENV.fetch('LDAP_BASE'), filter: filter, attributes: result_attrs, return_result: true)
  end
end

cn = 'Philip J. Fry'
login = 'fry'
password = 'fry'
email = 'fry@planetexpress.com'

ldap = ActiveDirectoryTest.valid_credentials?(cn: cn, password: password)
res = ActiveDirectoryTest.filter(ldap, %w[sAMAccountName fry])
pp 'filter res', res

ActiveDirectoryTest.valid_credentials?(cn: 'admin', password: 'GoodNewsEveryone')
