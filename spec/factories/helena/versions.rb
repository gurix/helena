FactoryGirl.define do
  factory :version, class: Helena::Version do
    sequence(:version)
    notes { Faker::Lorem.paragraphs(1).join('') }
    survey
  end

  factory :base_version, class: Helena::Version do
    version { 0 }
    notes { Faker::Lorem.paragraphs(1).join('') }
  end
end
