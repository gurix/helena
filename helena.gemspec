$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "helena/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "helena"
  s.version     = Helena::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Helena."
  s.description = "TODO: Description of Helena."

  s.files        = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")


  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
end
