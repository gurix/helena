# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey, class: Helena::Survey do
    sequence(:name)  { |n| "Survey #{n}" }
  end
end
