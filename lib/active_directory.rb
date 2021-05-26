require 'rubygems'
require 'net/ldap'

# docker run --rm -p 10389:10389 -p 10636:10636 rroemhild/test-openldap
# docker run -it --rm -p 10389:10389 dwimberger/ldap-ad-it

class ActiveDirectory
 # DOMAIN = 'dc=planetexpress,dc=com' #'planetexpress.com'
  DOMAIN = 'planetexpress'
  HOST = 'localhost'
  PORT = 10389  # ldap
  #PORT = 10636 # ldaps

  def self.valid_credentials?(login, password, email = nil)

    ldap1 = Net::LDAP.new(
      :host => HOST,
      :port => PORT,
      #:base => 'ou=people,dc=plantetexpress,dc=com',
      #:auth => {
        #:method => :simple,
        #username: login,
        #:username => 'ou=people,dc=planetexpress,dc=com', # server username
        #password: password # server pass
      #}

      #base:       "dc=#{DOMAIN},dc=com",
      # base: 'ou=people,dc=planetexpress,dc=com',
      #base: 'dc=wimpi,dc=net',
      # base: 'dc=wimpi,dc=net',
      #encryption: :simple_tls,
      auth:       {
        #username: "cn=Philip J. Fry,ou=people,dc=planetexpress,dc=com", # works
        #username: 'uid=fry,ou=people,dc=planetexpress,dc=com',
        username: 'uid=test,ou=users,dc=wimpi,dc=net',
        #username: 'cn=fry,dc=planetexpress,dc=com',
       # password: password,
        password: 'secret',
        method: :simple
      }
    )

    bound1= ldap1.bind
    if bound1
      puts 'bound1'
    else
      puts 'ldap1: ' + ldap1.get_operation_result.message
    end

    return

    ldap = Net::LDAP.new(
      :host => HOST,
      :port => PORT, # ldap

      # :encryption => :simple_tls,
      base:       "dc=#{DOMAIN},dc=com",
      :auth => {
        :method => :simple,
        :username => 'cn=admin,dc=planetexpress,dc=com', # server username
        :password => 'GoodNewsEveryone' # server pass
      }
    )

    #ldap.auth login, password

    bound = ldap.bind

    if bound
       puts 'bound2'
    #   res= ldap.search(
    #     base:         "ou=people,dc=planetexpress,dc=com",
    #     filter:       Net::LDAP::Filter.eq( "mail", email ),
    #     attributes:   %w[ displayName ],
    #     return_result:true
    #   ).first.displayName.first

    #   puts res

      # if email
      #   res = ldap.auth email, password
      #   puts 'auth res: ' + ldap.get_operation_result.message
      # end

      # filter = Net::LDAP::Filter.eq('sAMAccountName', login)
      # if ldap.bind_as(:filter => filter, :password => password)
      #   true
      # else
      #   puts "Active Directory validation failed for '#{login}': #{ldap.get_operation_result.message}"
      #   false
      # end

    else
      puts 'ldap not bind'
      puts ldap.get_operation_result.message
    end


    #puts '----------------'

    #ldap2_username = cn=Hubert J. Farnsworth,ou=people,dc=planetexpress,dc=com

    # ldap2 = Net::LDAP.new(
    #   :host => 'localhost',
    #   :port => 10389,
    #   :base => 'dc=planetexpress,dc=com',
    #   :auth => {
    #     :method => :simple,
    #     :username => login, # server username
    #     :password => password # server pass
    #   }
    # )

    # if ldap2.bind
    #   puts 'binded ldap2'

    # else
    #   puts ldap2.get_operation_result.message
    # end
  end
end

login = 'fry'
password = 'fry'
email = 'fry@planetexpress.com'

ActiveDirectory.valid_credentials?(login, password, email)
