require 'simplecov'
SimpleCov.start

require 'spec_helper'

require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'database_cleaner/active_record'
require 'database_cleaner/redis'
Dir[File.join(__dir__, 'fixtures/', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'support/', '*.rb')].sort.each { |file| require file }

require 'rspec/retry'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each do |f|
# require f
# end

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.include OmniauthMacros
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])

    Webpacker.compile

    FactoryBot.create(:time_range_type, name: 'Job Plan')
    FactoryBot.create(:time_range_type, name: 'RIO Data')
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include ActiveJob::TestHelper, type: :job

  config.include CapybaraHelpers, type: :feature
  config.include SessionHelpers, type: :feature

  # Show retry status in spec process.
  config.verbose_retry = true
  # Show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  # Run retry only on features.
  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end

  # Callback to be run between retries
  config.retry_callback = proc do |ex|
    # Run an additional clean up task in between retries to try and fix the flakiness.
    if ex.metadata[:js]
      Capybara.reset!
    end
  end
end

# Turn off deprecation notices
Selenium::WebDriver.logger.level = :error

OmniAuth.config.test_mode = true

Capybara.register_driver :chrome_headless do |app|
  args = %w[no-sandbox headless window-size=1400,1400]
  options = { 'goog:chromeOptions' => { 'args': args } }
  chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(options)
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: ENV['HEADLESS_CHROME_URL'],
                                 desired_capabilities: chrome_capabilities)
end

Capybara.register_driver :chrome_visible do |app|
  args = %w[no-sandbox window-size=1400,1400]
  options = { 'goog:chromeOptions' => { 'args': args } }
  chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(options)
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: ENV['VISIBLE_CHROME_URL'],
                                 desired_capabilities: chrome_capabilities)
end

Capybara.configure do |c|
  c.server_host = '0.0.0.0'
  c.server_port = 3001
  c.app_host = ENV['CAPYBARA_APP_HOST']
  c.default_normalize_ws = true
  c.default_max_wait_time = 10
  # Set c.javascript_driver = :chrome_visible to render on a visible copy of Chrome.
  # You can access it on a mac using `open vnc://0.0.0.0:5900`. The password is 'secret'.
  # Run a test with js:true to watch it play out, and use byebug to pause and interact.
  c.javascript_driver = :chrome_headless
  # c.javascript_driver = :chrome_visible
end
