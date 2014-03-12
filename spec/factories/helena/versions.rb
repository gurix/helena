FactoryGirl.define do
  factory :version, class: Helena::Version do
    sequence(:version)
    sequence(:title)  { |n| "Version #{n}" }
    notes { Faker::Lorem.paragraphs 1 }
    survey
  end
end
