FactoryGirl.define do
  factory :question, class: Helena::Question do
    sequence(:question_text)  { |n| "Question #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:position)
    sequence(:code) { |n| "X#{n}" }
    question_group

    factory :short_text_question, class: 'Helena::Questions::ShortText'
    factory :static_text_question, class: 'Helena::Questions::StaticText'
    factory :long_text_question, class: 'Helena::Questions::LongText'
  end
end
