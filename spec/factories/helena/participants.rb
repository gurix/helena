FactoryGirl.define do
  factory :participant, class: Helena::Participant do
    name Faker::Name.name
  end
end
