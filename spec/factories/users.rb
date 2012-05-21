FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:username) { |n| "user_#{n}" }
    
    after_create do |user|
      user.profile = FactoryGirl.create(:profile, :user => user)
    end
    
    factory :admin do
      after_create do |user|
        Rails.application.config.admins << user.username
      end
    end
  end
end