$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'helena/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'helena'
  s.version     = Helena::VERSION
  s.authors     = ['Markus Graf']
  s.email       = ['info@markusgraf.ch']
  s.homepage    = 'https://github.com/gurix/helena'
  s.summary     = 'Helena is an online survey/test framework designed for agile
survey/test development, longitudinal studies and instant feedback.'
  s.description = 'Helena is an online survey/test framework designed for agile
survey/test development, longitudinal studies and instant feedback.'

  s.files        = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.add_dependency 'rails', '~> 4.0.2'
  s.add_dependency 'haml'
  s.add_dependency 'haml-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sass-rails', '~> 4.0.0' # version needed here http://stackoverflow.com/questions/22392862/undefined-method-environment-for-nilnilclass-when-importing-bootstrap
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'simple_form'
  s.add_dependency 'breadcrumbs_on_rails'
  s.add_dependency 'rails-i18n'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'capybara'
end
