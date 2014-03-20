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
  satisfaction_survey = create :survey, name: 'The Satisfaction with Life Scale'
  satisfaction_survey_base_version = satisfaction_survey.versions.create version: 0
  satisfaction_survey_base_version.survey_detail = create(:survey_detail, title:       'The Satisfaction with Life Scale',
                                                                          description: 'A 5-item scale designed to measure global cognitive judgments of ones life satisfaction.',
                                                                          version:     satisfaction_survey_base_version)

  create :question_group, version: satisfaction_survey_base_version
end

def create_restaurant_survey
  description = <<EOF
Thank you for your recent stay at our hotel. During your stay you dined at our 5-star Swiss Cheese Restaurant.
We're conducting a short survey to find out about your dining experience and what we might do to improve.
Please help us by completing this short survey."
EOF

  restaurant_survey = create :survey, name: 'Restaurant customer satisfaction'
  restaurant_survey_base_version = restaurant_survey.versions.create version: 0
  restaurant_survey_base_version.survey_detail.create :survey_detail, title:       '5-star Swiss Cheese Restaurant customer satisfaction',
                                                                      version:     restaurant_survey_base_version,
                                                                      description: description

  personal_details = restaurant_survey_base_version.question_groups.create title: 'Personal Details', position: 1

  personal_details.questions.create code:           :name,
                                    question_text:  "What's your name?",
                                    position:       1,
                                    code:           'name',
                                    version:        restaurant_survey_base_version,
                                    type:           'Helena::Questions::ShortText'

  personal_details.questions.create code:           :email,
                                    question_text:  "What's your E-Mail-Address?",
                                    position:       2,
                                    version:        restaurant_survey_base_version,
                                    question_group: personal_details,
                                    type:           'Helena::Questions::ShortText'

  visit_interval = personal_details.questions.create code:           :visit_interval,
                                                      question_text:  'How often do you visit the Swiss Chees Restaurant?',
                                                      position:       3,
                                                      version:        restaurant_survey_base_version,
                                                      question_group: personal_details,
                                                      type:           'Helena::Questions::RadioGroup'

  visit_interval.labels.create position: 1, text: 'Just once', value: 1
  visit_interval.labels.create position: 2, text: 'Once a year', value: 2
  visit_interval.labels.create position: 3, text: 'Once a Month', value: 3
  visit_interval.labels.create position: 4, text: 'Once a week', value: 4
  visit_interval.labels.create position: 5, text: 'Daily', value: 5

  food_allergy = personal_details.questions.create code:           :food_allergy,
                                                   question_text:  'What kind of food allergy do you have?',
                                                   position:       4,
                                                   version:        restaurant_survey_base_version,
                                                   question_group: personal_details,
                                                   type:           'Helena::Questions::CheckboxGroup'

  food_allergy.sub_questions.create text: 'Garlic', code: 'garlic', position: 1
  food_allergy.sub_questions.create text: 'Oats', code: 'oat', position: 2
  food_allergy.sub_questions.create text: 'Meat', code: 'meat', position: 3
  food_allergy.sub_questions.create text: 'Milk', code: 'milk', position: 4
  food_allergy.sub_questions.create text: 'Peanut', code: 'peanut', position: 5
  food_allergy.sub_questions.create text: 'Fish / Shellfish', code: 'fish', position: 6
  food_allergy.sub_questions.create text: 'Soy', code: 'soy', position: 7
  food_allergy.sub_questions.create text: 'Wheat', code: 'wheat', position: 9
  food_allergy.sub_questions.create text: 'Gluten', code: 'gluten', position: 10
  food_allergy.sub_questions.create text: 'Egg', code: 'egg', position: 11
  food_allergy.sub_questions.create text: 'Sulfites', code: 'sulfites',  position: 12

  dinner = restaurant_survey_base_version.question_groups.create title: 'About the dinner', position: 2

  dinner.questions.create code:             :catchphrase,
                          question_text:    'How would you describe the dinner with one word?',
                          validation_rules: { presence: true },
                          position:         1,
                          version:          restaurant_survey_base_version,
                          question_group:   dinner,
                          type:             'Helena::Questions::ShortText'

  dinner.questions.create code:             :feedback,
                          question_text:    'Feel free to give us additional feedback ...',
                          position:         2,
                          version:          restaurant_survey_base_version,
                          question_group:   dinner,
                          type:             'Helena::Questions::LongText'

end

create_satisfaction_survey
create_restaurant_survey
