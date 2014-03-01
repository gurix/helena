FactoryGirl.define do
  factory :question, class: Helena::Question do
    sequence(:question_text)  { |n| "Question #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:position)
    question_group
  end
end
