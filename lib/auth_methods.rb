module AuthMethods
  %w[form oauth2 ldap].each do |m|
    define_singleton_method "#{m}?" do
      lambda { ENV['AUTH_METHOD'].split(',').include?(m) }
    end
  end
end
