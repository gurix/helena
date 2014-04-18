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

def create_satisfaction_scale_survey
  survey = create :survey, name: 'The Satisfaction with Life Scale'
  base_version = survey.versions.create version: 0
  base_version.survey_detail = create :survey_detail, title:       'The Satisfaction with Life Scale',
                                                      description: 'A 5-item scale designed to measure global cognitive judgments of ones life satisfaction.',
                                                      version:     base_version

  satisfaction_details = create :question_group, version: base_version

  satisfaction_matrix = satisfaction_details.questions.create code:             :satisfaction,
                                                              question_text:    'Below are five statements with which you may agree or disagree. Using the 1-7 scale below, indicate your agreement with each item by placing the appropriate number in the line preceding that item. Please be open and honest in your responding.',
                                                              validation_rules: { presence: true },
                                                              _type:            Helena::Questions::RadioMatrix,
                                                              position:         1

  satisfaction_matrix.labels.create position: 1, text: 'Strongly Disagree', value: 1
  satisfaction_matrix.labels.create position: 2, text: 'Disagree', value: 2
  satisfaction_matrix.labels.create position: 3, text: 'Slightly Disagree', value: 3
  satisfaction_matrix.labels.create position: 4, text: 'Neither Agree or Disagree', value: 4
  satisfaction_matrix.labels.create position: 5, text: 'Slightly Agree', value: 5
  satisfaction_matrix.labels.create position: 6, text: 'Agree', value: 6
  satisfaction_matrix.labels.create position: 7, text: 'Strongly Agree', value: 7

  satisfaction_matrix.sub_questions.create text: 'In most ways my life is close to my ideal.', code: 'life_is_ideal', position: 1
  satisfaction_matrix.sub_questions.create text: 'The conditions of my life are excellent.', code: 'condition', position: 2
  satisfaction_matrix.sub_questions.create text: 'I am satisfied with life.', code: 'satisfied_with_life', position: 3
  satisfaction_matrix.sub_questions.create text: 'So far I have gotten the important things I want in life.', code: 'important_things', position: 4
  satisfaction_matrix.sub_questions.create text: 'If I could live my life over, I would change almost nothing.', code: 'nothing_to_change', position: 5

  published_version = publish(base_version)

  rand(9).times { generate_sessions(survey, base_version) }
 end

def create_restaurant_survey
  description = <<EOF
Thank you for your recent stay at our hotel. During your stay you dined at our 5-star Swiss Cheese Restaurant.
We're conducting a short survey to find out about your dining experience and what we might do to improve.
Please help us by completing this short survey."
EOF

  survey = create :survey, name: 'Restaurant customer satisfaction'
  base_version = survey.versions.create version: 0
  base_version.survey_detail.create :survey_detail, title:      '5-star Swiss Cheese Restaurant customer satisfaction',
                                                    version:     base_version,
                                                    description: description

  personal_details = base_version.question_groups.create title: 'Personal Details', position: 1

  personal_details.questions.create code:           :name,
                                    question_text:  "What's your name?",
                                    position:       1,
                                    _type:          Helena::Questions::ShortText

  personal_details.questions.create code:           :email,
                                    question_text:  "What's your E-Mail-Address?",
                                    position:       2,
                                    _type:           Helena::Questions::ShortText

  visit_interval = personal_details.questions.create code:           :visit_interval,
                                                     question_text:  'How often do you visit the Swiss Chees Restaurant?',
                                                     position:       3,
                                                     _type:          Helena::Questions::RadioGroup

  visit_interval.labels.create position: 1, text: 'Just once', value: 1
  visit_interval.labels.create position: 2, text: 'Once a year', value: 2
  visit_interval.labels.create position: 3, text: 'Once a Month', value: 3
  visit_interval.labels.create position: 4, text: 'Once a week', value: 4
  visit_interval.labels.create position: 5, text: 'Daily', value: 5

  food_allergy = personal_details.questions.create code:           :food_allergy,
                                                   question_text:  'What kind of food allergy do you have?',
                                                   position:       4,
                                                   _type:          Helena::Questions::CheckboxGroup

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

  dinner = base_version.question_groups.create title: 'About the dinner', position: 2

  dinner.questions.create code:             :catchphrase,
                          question_text:    'How would you describe the dinner with one word?',
                          validation_rules: { presence: true },
                          position:         1,
                          _type:             Helena::Questions::ShortText

  dinner.questions.create code:             :feedback,
                          question_text:    'Feel free to give us additional feedback ...',
                          position:         2,
                          _type:            Helena::Questions::LongText

  restaurant = base_version.question_groups.create title: 'About the restaurant', position: 3

  brand_attributes = restaurant.questions.create code:          :brand_attributes,
                                                 question_text: 'What words describe the following topics best?',
                                                 position:       1,
                                                 _type:          Helena::Questions::CheckboxMatrix

  brand_attributes.labels.create position: 1, text: 'calm', value: 'calm'
  brand_attributes.labels.create position: 2, text: 'energetic', value: 'energetic'
  brand_attributes.labels.create position: 3, text: 'friendly', value: 'friendly'
  brand_attributes.labels.create position: 4, text: 'funny', value: 'funny'
  brand_attributes.labels.create position: 5, text: 'modest', value: 'modest'
  brand_attributes.labels.create position: 6, text: 'warmhearted', value: 'warmhearted'
  brand_attributes.labels.create position: 7, text: 'sociable', value: 'sociable'
  brand_attributes.labels.create position: 8, text: 'romantic', value: 'romantic'

  brand_attributes.sub_questions.create position: 1, text: 'Restaurant', code: 'restaurant'
  brand_attributes.sub_questions.create position: 2, text: 'Staff', code: 'staff'
  brand_attributes.sub_questions.create position: 3, text: 'Food', code: 'food'
  brand_attributes.sub_questions.create position: 4, text: 'Drinks', code: 'drinks'
  brand_attributes.sub_questions.create position: 5, text: 'Atmosphere', code: 'atmosphere'

  publish(base_version)
  rand(9).times { generate_sessions(survey, base_version) }
end

def publish(version)
  published_version = Helena::VersionPublisher.publish(version)
  published_version.notes = Faker::Lorem.paragraph(1)
  published_version.save
  published_version
end

def generate_sessions(survey, version)
  survey.sessions.create version: version, updated_at: DateTime.now - rand(999)
end

create_satisfaction_scale_survey
create_restaurant_survey
