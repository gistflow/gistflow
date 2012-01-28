FactoryGirl.define do
  factory :post do
    user
    title { Faker::Lorem.sentence }
    body { "#{Faker::Lorem.paragraph}" }
    
    trait :with_gist do
      body { "#{Faker::Lorem.paragraph} {gist:777}" }
    end
    
    factory :post_with_gist, :traits => [:with_gist]
  end  
end
