module RequestSessionHelpers
  def log_in(user)
    if ENV['AUTH_METHOD'] == 'oauth2'
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(user_id: user.id)
    else
      login_as user, scope: :user # from Devise https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    end
  end
end
