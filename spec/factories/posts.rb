FactoryGirl.define do
  factory :post, :class => "Post::Article" do
    user
    title { Faker::Lorem.paragraph }
    content { Faker::Lorem.paragraph }
    
    trait :with_gist do
      content { "#{Faker::Lorem.paragraph} {gist:777}" }
    end
    
    trait :with_tag do
      content { "#tag_1 #{Faker::Lorem.paragraph}" }
    end
    
    factory :post_with_gist, :traits => [:with_gist]
    factory :post_with_tag, :traits => [:with_tag]
  end
  
  factory :gossip, :class => "Post::Gossip" do
    user
    content { Faker::Lorem.paragraph }
  end
end
