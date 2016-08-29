FactoryGirl.define do
  factory :question, class: Helena::Question do
    sequence(:question_text)  { |n| "Question #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:code) { |n| "x#{n}" }
    question_group

    factory :short_text_question, class: Helena::Questions::ShortText
    factory :static_text_question, class: Helena::Questions::StaticText
    factory :long_text_question, class: Helena::Questions::LongText
    factory :radio_group_question, class: Helena::Questions::RadioGroup
    factory :checkbox_group_question, class: Helena::Questions::CheckboxGroup
    factory :radio_matrix_question, class: Helena::Questions::RadioMatrix
    factory :bipolar_radio_matrix_question, class: Helena::Questions::BipolarRadioMatrix
  end
end
