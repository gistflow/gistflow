FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }
    company { Faker::Name.name }
    home_page { "http://#{Faker::Internet.domain_name}" }
    github_page { "http://github.com/#{Faker::Name.name}" }
    
    factory :admin do
      after_create do |user|
        Rails.application.config.admins << user.username
      end
    end
  end
end
