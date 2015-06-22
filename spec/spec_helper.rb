require 'faker'
require 'coveralls'

Coveralls.wear!

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'mongoid-rspec'
require 'capybara/rspec'
require 'rspec/collection_matchers'

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.order = :random
  config.include ActionView::RecordIdentifier, type: :feature

  config.include Mongoid::Matchers, type: :model

  # We don't want write FactoryGirl all the time
  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
