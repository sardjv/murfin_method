sidekiq_config = if ENV['REDIS_PASSWORD']
                   { url: "redis://:#{ENV['REDIS_PASSWORD']}@redis:#{ENV['REDIS_PORT']}/0" }
                 else
                   { url: ENV['REDIS_URL'] }
                 end

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
