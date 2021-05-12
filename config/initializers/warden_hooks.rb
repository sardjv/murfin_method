Warden::Manager.after_set_user do |user, auth, _opts|
  # scope = opts[:scope]
  auth.cookies.signed[:user_id] = user.id
  # auth.cookies.signed["#{scope}.expires_at"] = 30.minutes.from_now
end

Warden::Manager.before_logout do |_user, auth, _opts|
  # scope = opts[:scope]
  # auth.cookies.signed[:user_id] = nil
  auth.cookies.delete :user_id
  # auth.cookies.signed["#{scope}.expires_at"] = nil
end
