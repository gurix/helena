FactoryGirl.define do
  factory :survey, class: Helena::Survey do
    sequence(:name)  { |n| "Survey #{n}" }
    sequence(:position)
  end
end
