FactoryGirl.define do
  factory :comment do
    user
    body { "#{Faker::Lorem.paragraph}" }
    
    trait :with_mention do
      body { " @user_1 #{Faker::Lorem.paragraph}" }
    end
    
    factory :comment_with_mention, :traits => [:with_mention]
  end
end
