# Borrowed from: https://github.com/DFE-Digital/apply-for-postgraduate-teacher-training/pull/2275/files/16d2ad7ae053247760cf3905cdbacfdf4ec4b7ea
# https://github.com/mperham/sidekiq/issues/4591
# Fix for Redis being noisy about an upcoming change. Remove once Sidekiq
# is on version 6.1+.
unless Gem::Version.new(Sidekiq::VERSION) < Gem::Version.new('6.1')
  raise 'You can now remove the file config/initializers/redis.rb!'
end

Redis.exists_returns_integer = true
