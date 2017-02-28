FactoryGirl.define do
  factory :survey_detail, class: Helena::SurveyDetail do
    sequence(:title) { |n| "Survey #{n}, #{Faker::Lorem.words(3).join(' ')}?" }
    sequence(:description) { Faker::Lorem.paragraphs(3).join(' ') }
    version
  end
end
