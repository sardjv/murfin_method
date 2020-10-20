module SessionHelpers
  def log_in(user)
    mock_valid_auth_hash(user)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]
    Rails.application.env_config['omniauth.params'] = { 'login' => '' }
    visit '/auth/auth0/callback'
  end
end
