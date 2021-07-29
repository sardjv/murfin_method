# https://github.com/wardencommunity/warden/wiki/Callbacks#after_set_user
Warden::Manager.after_set_user do |user, auth, _opts|
  # scope = opts[:scope]
  auth.cookies.signed[:user_id] = user.id

  auth.request.session[:user_id] = user.id
  auth.request.session[:auth_method] = auth.request.env['warden'].winning_strategy.class.name.include?('LdapAuthenticatable') ? 'ldap' : 'form'

  # auth.cookies.signed["#{scope}.expires_at"] = 30.minutes.from_now
end

# https://github.com/wardencommunity/warden/wiki/Callbacks#before_logout
Warden::Manager.before_logout do |_user, auth, _opts|
  # scope = opts[:scope]
  auth.cookies.delete :user_id
  # auth.cookies.signed["#{scope}.expires_at"] = nil
end
