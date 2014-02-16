# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_group do
    sequence(:title)  { |n| "Page #{n}" }
  end
end
