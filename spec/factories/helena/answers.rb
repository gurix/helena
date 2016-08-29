FactoryGirl.define do
  factory :answer, class: Helena::Answer do
    sequence(:code)  { |n| "answer_#{n}" }
    sequence(:ip_address) {  Faker::Internet.ip_v4_address }
    session
  end

  factory :string_answer, class: Helena::StringAnswer do
    sequence(:code)  { |n| "string_answer_#{n}" }
    sequence(:value) {  Faker::Lorem.word }
    sequence(:ip_address) {  Faker::Internet.ip_v4_address }
    session
  end

  factory :integer_answer, class: Helena::IntegerAnswer do
    sequence(:code)  { |n| "integer_answer_#{n}" }
    sequence(:value) { rand 99 }
    sequence(:ip_address) {  Faker::Internet.ip_v4_address }
    session
  end

  factory :boolean_answer, class: Helena::BooleanAnswer do
    sequence(:code)  { |n| "boolean_answer_#{n}" }
    sequence(:value) { [true, false].sample }
    sequence(:ip_address) {  Faker::Internet.ip_v4_address }
    session
  end
end
