FactoryGirl.define do
  factory :post do
    user
    content { Faker::Lorem.paragraph }
    trait :with_gist do
      content { "#{Faker::Lorem.paragraph} {gist:777}" }
    end
    factory :post_with_gist, :traits => [:with_gist]
  end  
end
