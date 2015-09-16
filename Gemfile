source 'https://rubygems.org'

# Declare your gem's dependencies in helena.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem 'mongoid-tree', github: 'gurix/mongoid-tree', branch: 'mongoid-5.0'

# To use debugger
group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'ruby-progressbar'
  # TODO: Change this after https://github.com/mongoid-rspec/mongoid-rspec/pull/158 is merged
  gem 'mongoid-rspec', github: '90yukke/mongoid-rspec', branch: 'feature/support-mongoid-5.0.0'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'launchy'
  gem 'binding_of_caller'
  gem 'selenium-webdriver'
  gem 'i18n-tasks'
  gem 'simple_form'
  gem 'jquery-rails'
  gem 'bootstrap-sass'
  gem 'breadcrumbs_on_rails'
  gem 'coveralls', require: false
  gem 'shoulda-matchers'
  # TODO: Change this as soon as version 1.5.1 was bumped on rubygems
  gem 'database_cleaner', github: 'DatabaseCleaner/database_cleaner'
end
