source 'https://rubygems.org'
ruby '3.0.0'

# Make it easy to create beautiful-looking forms using Bootstrap 4.
# https://github.com/bootstrap-ruby/bootstrap_form
gem 'bootstrap_form', '~> 4.0'

# Dynamic nested forms using jQuery made easy.
# https://github.com/nathanvda/cocoon
gem 'cocoon', '~> 1.2.15'

# Easily manage your environment.
# https://github.com/thoughtbot/climate_control
gem 'climate_control'

# Devise is a flexible authentication solution for Rails based on Warden.
# https://github.com/heartcombo/devise
gem 'devise', '~> 4.7.3'

# Better distance of time in words for Rails.
# https://github.com/radar/distance_of_time_in_words
gem 'dotiw', '~> 5.2.0'

# Fixtures replacement with a straightforward definition syntax.
# https://github.com/thoughtbot/factory_bot
gem 'factory_bot', '~> 6.1.0'

# Generate fake data such as names, addresses, and phone numbers.
# https://github.com/faker-ruby/faker
gem 'faker', '~> 2.16.0'

# Allows easy creation of recurrence rules and fast querying.
# https://github.com/seejohnrun/ice_cube
gem 'ice_cube', '~> 0.16.3'

# A resource-focused Rails library for developing JSON:API compliant servers.
# https://github.com/cerebris/jsonapi-resources
gem 'jsonapi-resources', '~> 0.10.4'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
# https://github.com/jwt/ruby-jwt
gem 'jwt', '~> 2.2.2'

# paginator for modern web app frameworks and ORMs.
# https://github.com/kaminari/kaminari
gem 'kaminari', '~> 1.2.1'

# Use MySQL as the database for Active Record.
# https://github.com/brianmario/mysql2
gem 'mysql2', '~> 0.5.3'

# OmniAuth is a flexible authentication system utilizing Rack middleware.
# https://github.com/auth0/omniauth-auth0
gem 'omniauth-auth0', '~> 2.5.0'

# Provides CSRF protection on OmniAuth request endpoint on Rails application.
# https://github.com/cookpad/omniauth-rails_csrf_protection
gem 'omniauth-rails_csrf_protection', '~> 0.1.2'

# A Ruby parser - used by Rubocop, added here to force it to a newer version
# for compatibility with Ruby 3.0.0.
# https://github.com/whitequark/parser
gem 'parser', '~> 3.0.0.0'

# A Ruby/Rack web server built for concurrency.
# https://github.com/puma/puma
gem 'puma', '~> 5.2.1'

# Minimal authorization through OO design and pure Ruby classes.
# https://github.com/varvet/pundit
gem 'pundit', '~> 2.1.0'

# Create database-backed web applications using the MVC pattern.
# https://github.com/rails/rails
gem 'rails', '~> 6.1.2'

# A very fast key-value store to hold jobs until they are run.
# https://github.com/redis/redis-rb
gem 'redis', '~> 4.2.5'

# Serve Swagger documentation generated from RSpec tests.
# https://github.com/rswag/rswag
gem 'rswag-api', '~> 2.4.0'
gem 'rswag-ui', '~> 2.3.3'

# Simple, efficient background processing for Ruby.
# https://github.com/mperham/sidekiq
gem 'sidekiq', '~> 6.1.3'

# Bundle zoneinfo files which are not included in Windows.
# https://github.com/tzinfo/tzinfo-data
gem 'tzinfo-data', '~> 1.2021.1'

# Use Webpack to manage app-like JavaScript modules in Rails.
# https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2.1'

group :development, :test do
  # Call 'binding.pry' anywhere in your code to drop into a debugger console.
  # https://github.com/pry/pry
  gem 'pry', '~> 0.14.0'

  # Generate Swagger docs from RSpec tests.
  # https://github.com/rswag/rswag
  gem 'rswag-specs', '~> 2.4.0'

  # A memory profiler for Ruby.
  # https://github.com/SamSaffron/memory_profiler
  gem 'memory_profiler', '~> 1.0.0'

  # Rails SQL Query Tracker.
  # https://github.com/steventen/sql_tracker
  gem 'sql_tracker', '~> 1.3.1'
end

group :development do
  # Annotate Rails classes with schema and routes info.
  # https://github.com/ctran/annotate_models
  gem 'annotate', '~> 3.1.1'

  # Automates various tasks by running custom rules when files are changed.
  # https://github.com/guard/guard-rspec
  gem 'guard-rspec', '~> 4.7.3'

  # Automatically check Ruby code style with RuboCop when files are modified.
  # https://github.com/yujinakayama/guard-rubocop
  gem 'guard-rubocop', '~> 1.4.0'

  # Listens to file modifications and notifies you about the changes.
  # https://github.com/guard/listen
  gem 'listen', '~> 3.4.1'

  # A static code analyzer and formatter, based on the community style guide.
  # https://github.com/rubocop-hq/rubocop-rails
  gem 'rubocop-rails', '~> 2.9.1'
end

group :test do
  # Acceptance test framework for web applications.
  # https://github.com/teamcapybara/capybara
  gem 'capybara', '~> 3.35.3'

  # Strategies for cleaning databases between tests.
  # https://github.com/DatabaseCleaner/database_cleaner
  gem 'database_cleaner-active_record', '~> 2.0.0'

  # RSpec results that your CI can read.
  # https://github.com/sj26/rspec_junit_formatter
  gem 'rspec_junit_formatter', '~> 0.4.1'

  # RSpec is a specification library for behaviour driven development.
  # https://github.com/rspec/rspec
  gem 'rspec-rails', '~> 4.0.2'

  # Retry flaky specs to reduce time spent on random failures.
  # https://github.com/noredink/rspec-retry
  gem 'rspec-retry', '~> 0.6.2'

  # A browser automation framework and ecosystem.
  # https://github.com/SeleniumHQ/selenium
  # Use edge until v4.0.0 of this gem is released, for Ruby 3.0.0 compatability.
  gem 'selenium-webdriver', github: 'SeleniumHQ/selenium', ref: '8e5a9ede90137c048715125a14be3c25c08a51e7'

  # Simple one-liner tests for common Rails functionality.
  # https://github.com/thoughtbot/shoulda-matchers
  gem 'shoulda-matchers', '~> 4.5.1'

  # Generate code coverage documentation.
  # https://github.com/colszowka/simplecov
  gem 'simplecov', '~> 0.21.2'

  # Provides 'time travel' capabilities, making it simple to test time-dependent code.
  # https://github.com/travisjeffery/timecop
  gem 'timecop', '~> 0.9.4'
end
