# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participant, class: Helena::Participant do
    name Faker::Name.name
  end
end
