FactoryGirl.define do
  factory :post, :class => "Post::Article" do
    user
    content { Faker::Lorem.paragraph }
    tag_names { Faker::Lorem.words(3).join(',') }
    trait :with_gist do
      content { "#{Faker::Lorem.paragraph} {gist:777}" }
    end
    factory :post_with_gist, :traits => [:with_gist]
  end  
end
