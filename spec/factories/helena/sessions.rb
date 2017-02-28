FactoryGirl.define do
  factory :session, class: Helena::Session do
    sequence(:token) { |n| "token_#{n}" }
    survey
    version
  end

  factory :session_without_token, class: Helena::Session do
    survey
    version
  end
end
