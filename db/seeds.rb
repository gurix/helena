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

satisfaction_survey = create :survey, name: 'The Satisfaction with Life Scale',
                                      description: 'A 5-item scale designed to measure global cognitive judgments of ones life satisfaction.'
create :question_group, survey: satisfaction_survey

description = <<EOF
Thank you for your recent stay at our hotel. During your stay you dined at our 5-star Swiss Cheese Restaurant.
We're conducting a short survey to find out about your dining experience and what we might do to improve.
Please help us by completing this short survey."
EOF
restaurant_survey = create :survey, name: 'Restaurant customer satisfaction', description: description

personal_details = create :question_group, survey: restaurant_survey, title: 'Personal Details'

personal_details.questions << create(:short_text_question, code: :name, question_text: "What's your name?", validation_rules: { presence: true })
