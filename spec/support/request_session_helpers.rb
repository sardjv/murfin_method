module RequestSessionHelpers
  def log_in(user)
    auth_methods_enabled = ENV['AUTH_METHOD']&.split(',') || []

    if (auth_methods_enabled & ['form', 'ldap']).any?
      login_as user, scope: :user # from Devise https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    else
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(user_id: user.id, auth_method: 'oauth2')
    end
  end
end
