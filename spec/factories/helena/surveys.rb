FactoryBot.define do
  factory :survey, class: Helena::Survey do
    sequence(:name) { |n| "Survey #{n}" }
    language 'en'
  end
end
