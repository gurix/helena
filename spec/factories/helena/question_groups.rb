FactoryGirl.define do
  factory :question_group, class: Helena::QuestionGroup do
    sequence(:title) { |n| "Page #{n}" }
    version
  end
end
