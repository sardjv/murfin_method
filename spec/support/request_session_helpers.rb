module RequestSessionHelpers
  def log_in(user)
    if ENV['AUTH_METHOD'] == 'form' || ENV['AUTH_METHOD'] == 'ldap'
      login_as user, scope: :user # from Devise https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    else
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(user_id: user.id, auth_method: 'oauth2')
    end
  end
end
