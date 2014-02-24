require 'factory_girl'
require 'ffaker'
require 'database_cleaner'

include FactoryGirl::Syntax::Methods

# TODO: Codes smells because we have to assign the factory path here
FactoryGirl.definition_file_paths += ['spec/factories']
FactoryGirl.find_definitions

puts 'Cleaning database ...'.green
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

puts 'Seeding surveys ...'.green
create :survey, name: 'Some test survey', description: Faker::Lorem.paragraph(1)
create :survey, name: 'Another stupid questionary', description: Faker::Lorem.paragraph(1)
