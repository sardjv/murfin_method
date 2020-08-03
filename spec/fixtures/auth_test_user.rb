module AuthTestUser
  USERINFO = {
    'provider' => 'auth0',
    'uid' => 'google-oauth2|10101010101010101010',
    'info' => {
      'name' => 'John Smith',
      'email' => 'john@example.com'
    },
    'extra' => {
      'raw_info' => {
        'given_name' => 'John',
        'family_name' => 'Smith'
      }
    }
  }.freeze
end
