module FeatureSessionHelpers
  def log_in(user)
    if ENV['AUTH_METHOD'] == 'form'
      login_as user, scope: :user # from Devise https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    else
      mock_valid_auth_hash(user)
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]
      Rails.application.env_config['omniauth.params'] = { 'login' => '' }
      visit '/auth/auth0/callback'
    end
  end
end
