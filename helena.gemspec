$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'helena/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'helena'
  s.version     = Helena::VERSION
  s.authors     = ['Markus Graf']
  s.email       = ['info@markusgraf.ch']
  s.licenses    = ['GPL-3']
  s.homepage    = 'https://github.com/gurix/helena'
  s.summary     = 'Helena is an online survey/test framework designed for agile
survey/test development, longitudinal studies and instant feedback.'
  s.description = 'Helena is an online survey/test framework designed for agile
survey/test development, longitudinal studies and instant feedback.'

  s.files        = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'mongoid', '~> 4.0'
  s.add_dependency 'mongoid_orderable', '~> 4.1'
  s.add_dependency 'mongoid-simple-tags', '~> 0.1'
  s.add_dependency 'haml-rails', '~> 0.9'
  s.add_dependency 'slim', '~> 3.0'
  s.add_dependency 'jquery-rails', '~> 4.0'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'bootstrap-sass', '~> 3.2'
  s.add_dependency 'simple_form', '~> 3.1.0.rc2'
  s.add_dependency 'breadcrumbs_on_rails', '~> 2.3'
  s.add_dependency 'rails-i18n', '~> 4.0'
  s.add_dependency 'responders', '~> 2.0'
  s.add_dependency 'browser', '~> 0.8'
  s.add_dependency 'mongoid-tree', '~> 2.0'

  s.add_development_dependency 'rspec-rails', '~> 3'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1'
  s.add_development_dependency 'factory_girl_rails', '~> 4.4'
  s.add_development_dependency 'database_cleaner', '~> 1.3'
  s.add_development_dependency 'faker', '~> 1.4'
  s.add_development_dependency 'capybara', '~> 2.3'
end
