FactoryGirl.define do
  factory :comment do
    body { "#{Faker::Lorem.paragraph}" }
    
    trait :with_consignee do
      body { " @user_1 #{Faker::Lorem.paragraph}" }
    end
    
    factory :comment_with_consignee, :traits => [:with_consignee]
  end
end
