FactoryGirl.define do
  factory :session, class: Helena::Session do
    sequence(:token)  { |n| "token_#{n}" }
  end

  factory :session_without_token, class: Helena::Session do
  end
end
