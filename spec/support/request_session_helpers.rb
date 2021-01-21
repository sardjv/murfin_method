module RequestSessionHelpers
  def log_in(user)
    # stub_env('AUTH_METHOD', 'oauth2')

    allow_any_instance_of(ApplicationController).to receive(:session).and_return(userinfo: mock_valid_auth_hash(user))
  end
end
