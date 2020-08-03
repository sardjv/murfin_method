# Mock users as authenticated for tests.
module SecuredWithOauth
  def session
    { userinfo: AuthTestUser::USERINFO }
  end
end
