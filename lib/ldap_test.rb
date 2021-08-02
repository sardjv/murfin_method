# rubocop:disable Rails/Output

require 'rubygems'
require 'net/ldap'

# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/
# ldapsearch -h ldap.forumsys.com -D "uid=tesla,dc=example,dc=com" -b "dc=example,dc=com" -w password -d 1
# password: password
# ldapwhoami -H ldap://ldap.forumsys.com -x

# bundle exec rails runner lib/ldap_test.rb

class LdapTest
  def self.bind # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    host = ENV.fetch('LDAP_AUTH_HOST')
    port = ENV.fetch('LDAP_AUTH_PORT')
    base = ENV.fetch('LDAP_AUTH_BASE')
    bind_key = ENV.fetch('LDAP_AUTH_BIND_KEY')
    bind_value = ENV.fetch('LDAP_AUTH_BIND_VALUE')
    upn_suffix = ENV['LDAP_AUTH_UPN_SUFFIX'] # upn prefix is taken from bind value
    password = ENV.fetch('LDAP_AUTH_PASSWORD')
    encrypted = ENV['LDAP_AUTH_ENCRYPTED']&.as_boolean

    username = if (bind_key.downcase == 'userprincipalname' || bind_key.downcase == 'samaccountname') && upn_suffix.present?
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

    attrs[:encryption] = :simple_tls if encrypted
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
    puts "LDAP filter args: #{args.inspect}"
    filter = Net::LDAP::Filter.eq(*args)
    # result_attrs = %w[sAMAccountName displayName mail]
    # base: base, attributes: attributes: result_attrs
    ldap.search(filter: filter, return_result: true)
  end
end

ldap = LdapTest.bind

pp 'LDAP search results:', LdapTest.filter(ldap, [ENV['LDAP_AUTH_BIND_KEY'], ENV['LDAP_AUTH_BIND_VALUE']])

# rubocop:enable Rails/Output
