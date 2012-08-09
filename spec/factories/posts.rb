FactoryGirl.define do
  factory :post do
    user
    title { Faker::Lorem.paragraph[0...255] }
    content { Faker::Lorem.paragraph << " #tag " }
    
    trait :with_gist do
      content { "#{Faker::Lorem.paragraph} {gist:777}" }
    end
    
    trait :with_tag do
      content { "#tag_1 #{Faker::Lorem.paragraph}" }
    end
    
    factory :post_with_gist, :traits => [:with_gist]
    factory :post_with_tag, :traits => [:with_tag]
    
    factory :private_post do
      is_private true
    end
  end
end