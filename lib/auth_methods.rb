module AuthMethods
  AUTH_METHODS_ENABLED = ENV['AUTH_METHOD'].split(',')

  %w[form oauth2 ldap].each do |m|
    define_singleton_method "#{m}?" do
      AUTH_METHODS_ENABLED.include?(m)
    end
  end
end
