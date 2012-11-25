FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }

    after(:create) do |user|
      create(:account_github, user: user)
    end

    factory :admin do
      after(:create) do |user|
        Rails.application.config.admins << user.username
      end
    end
  end
end