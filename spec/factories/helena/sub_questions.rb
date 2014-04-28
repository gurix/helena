FactoryGirl.define do
  factory :sub_question, class: Helena::SubQuestion do
    sequence(:text)  { |n| "Question #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:code) { |n| "y#{n}" }
    sequence(:position)
  end
end
