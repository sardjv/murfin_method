# frozen_string_literal: true

redis_params = { url: "#{ENV['REDIS_URL'] || "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}"}/1" }
redis_params[:password] = ENV['REDIS_PASSWORD'] if ENV['REDIS_PASSWORD']
REDIS_CLIENT = Redis.new(redis_params)
