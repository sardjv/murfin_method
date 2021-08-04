Rails.application.reloader.to_prepare do
  AUTH_CONFIG = AuthConfig.instance
end
