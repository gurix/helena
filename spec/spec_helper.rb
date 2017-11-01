require 'faker'

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'factory_bot_rails'
require 'mongoid-rspec'
require 'capybara/rspec'
require 'rspec/collection_matchers'

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

Mongoid.configure do |config|
  config.connect_to('helena_adminstration_test')
end

Mongo::Logger.logger.level = Logger::WARN # Set log level to DEBUG to see everything

RSpec.configure do |config|
  config.order = :random
  config.include ActionView::RecordIdentifier, type: :feature

  config.include Mongoid::Matchers, type: :model

  # We don't want write FactoryBot all the time
  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.after(:each) do
    Mongoid.purge!
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :active_model
    with.library :action_controller
  end
end
