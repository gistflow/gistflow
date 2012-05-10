FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:username) { |n| "user_#{n}" }
    association :profile
    
    factory :admin do
      after_create do |user|
        Rails.application.config.admins << user.username
      end
    end
  end
end
