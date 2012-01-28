FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }
  end
end
