module OmniauthMacros
  def mock_valid_auth_hash(user) # rubocop:disable Metrics/MethodLength
    opts = {
      provider: 'auth0',
      uid: 'auth0|12341234',
      info: {
        name: user.name,
        nickname: user.name,
        email: user.email,
        image: 'https://example.com/photo.jpg'
      },
      credentials: {
        token: 'fake-test-token',
        expires_at: 1_562_777_110,
        expires: true,
        id_token: 'kljef76786sdf-some-fake-token-for-test',
        token_type: 'Bearer',
        refresh_token: nil
      },
      extra: {
        raw_info: {
          sub: 'auth0|12341234',
          given_name: user.first_name,
          family_name: user.last_name,
          nickname: user.name,
          name: user.name,
          picture: 'https://example.com/photo.jpg',
          gender: 'male',
          locale: 'en',
          updated_at: '2019-07-09T16:45:09.769Z',
          email: user.email,
          email_verified: true
        }
      }
    }
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(opts)
  end
end
