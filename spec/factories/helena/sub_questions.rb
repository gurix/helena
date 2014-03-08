FactoryGirl.define do
  factory :sub_question, class: Helena::SubQuestion do
    sequence(:question_text)  { |n| "Question #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:code) { |n| "Y#{n}" }
    sequence(:position)
    question
  end
end
