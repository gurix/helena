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

def create_satisfaction_survey
  satisfaction_survey = create :survey, name:        'The Satisfaction with Life Scale',
                                        description: 'A 5-item scale designed to measure global cognitive judgments of ones life satisfaction.'
  create :question_group, survey: satisfaction_survey
end

def create_restaurant_survey
  description = <<EOF
Thank you for your recent stay at our hotel. During your stay you dined at our 5-star Swiss Cheese Restaurant.
We're conducting a short survey to find out about your dining experience and what we might do to improve.
Please help us by completing this short survey."
EOF

  restaurant_survey = create :survey, name: 'Restaurant customer satisfaction', description: description

  personal_details = create :question_group, survey: restaurant_survey, title: 'Personal Details', position: 1

  personal_details.questions << create(:short_text_question, code:           :name,
                                                             question_text:  "What's your name?",
                                                             position:       1,
                                                             code:           'name',
                                                             survey:         restaurant_survey,
                                                             question_group: personal_details)
  personal_details.questions << create(:short_text_question, code: :email,
                                                             question_text:  "What's your E-Mail-Address?",
                                                             position:       2,
                                                             survey:         restaurant_survey,
                                                             question_group: personal_details)

  personal_details.questions << create(:radio_group_question, code: :visit_intervall,
                                       question_text:  'How often do you visit the Swiss Chees Restaurant?',
                                       position:       3,
                                       survey:         restaurant_survey,
                                       question_group: personal_details,
                                       labels:         [build(:label, position: 1, text: 'Just once', value: 1),
                                                        build(:label, position: 2, text: 'Once a year', value: 2),
                                                        build(:label, position: 3, text: 'Once a Month', value: 3),
                                                        build(:label, position: 4, text: 'Once a week', value: 4),
                                                        build(:label, position: 5, text: 'Daily', value: 5)])

  personal_details.questions << create(:checkbox_group_question, code: :food_allergy,
                                       question_text:  'What kind of food allergy do you have?',
                                       position:       4,
                                       survey:         restaurant_survey,
                                       question_group: personal_details,
                                       sub_questions:  [build(:sub_question, text: 'Garlic', code: 'garlic', position: 1),
                                                        build(:sub_question, text: 'Oats', code: 'oat', position: 2),
                                                        build(:sub_question, text: 'Meat', code: 'meat', position: 3),
                                                        build(:sub_question, text: 'Milk', code: 'milk', position: 4),
                                                        build(:sub_question, text: 'Peanut', code: 'peanut', position: 5),
                                                        build(:sub_question, text: 'Fish / Shellfish', code: 'fish', position: 6),
                                                        build(:sub_question, text: 'Soy', code: 'soy', position: 7),
                                                        build(:sub_question, text: 'Tree nut', code: 'tree_nut', position: 8),
                                                        build(:sub_question, text: 'Wheat', code: 'wheat', position: 9),
                                                        build(:sub_question, text: 'Gluten', code: 'gluten', position: 10),
                                                        build(:sub_question, text: 'Egg', code: 'egg', position: 11),
                                                        build(:sub_question, text: 'Sulfites', code: 'sulfites',  position: 12)])



  dinner = create :question_group, survey: restaurant_survey, title: 'About the dinner', position: 2
  dinner.questions << create(:short_text_question, code:             :catchphrase,
                                                   question_text:    'How would you describe the dinner with one word?',
                                                   validation_rules: { presence: true },
                                                   position:         1,
                                                   survey:           restaurant_survey,
                                                   question_group:   dinner)
  dinner.questions << create(:long_text_question, code:             :feedback,
                                                  question_text:    'Feel free to give us additional feedback ...',
                                                  position:         2,
                                                  survey:           restaurant_survey,
                                                  question_group:   dinner)

end

create_satisfaction_survey
create_restaurant_survey
