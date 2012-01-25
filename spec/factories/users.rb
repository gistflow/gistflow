FactoryGirl.define do
  factory :user do
    name { "Mad Max" }
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }
  end
end
