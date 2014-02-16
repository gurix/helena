# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey do
    sequence(:name)  { |n| "Survey #{n}" }
  end
end
