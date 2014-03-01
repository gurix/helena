FactoryGirl.define do
  factory :question_group, class: Helena::QuestionGroup do
    sequence(:title)  { |n| "Page #{n}" }
    sequence(:position)
    survey
  end
end
