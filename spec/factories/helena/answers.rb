FactoryGirl.define do
  factory :answer, class: Helena::Answer do
    sequence(:code)  { |n| "x#{n}" }
    sequence(:value) {  Faker::Skill.tech_skill }
    sequence(:ip_address) {  Faker::Internet.ip_v4_address }
  end
end
