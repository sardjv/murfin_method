# frozen_string_literal: true

redis_url = ENV['REDIS_URL'] || "redis://redis:#{ENV['REDIS_PORT']}/1"
REDIS_CLIENT = Redis.new({ url: redis_url, password: ENV['REDIS_PASSWORD'] })
