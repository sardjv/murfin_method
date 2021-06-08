sidekiq_config = if ENV['REDIS_URL'] && !ENV['REDIS_PASSWORD']
                   { url: "#{ENV['REDIS_URL']}/0" }
                 else
                   { url: "redis://:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0" }
                 end

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
