FactoryBot.define do
  factory :version, class: Helena::Version do
    sequence(:version)
    notes { Faker::Lorem.paragraph }
    survey
  end

  factory :base_version, class: Helena::Version do
    version { 0 }
    notes { Faker::Lorem.paragraph }
    survey
  end
end
