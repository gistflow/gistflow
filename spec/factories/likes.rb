# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    user
    
    trait :for_comment do
      association :likable, :factory => :comment
    end
    
    trait :for_post do
      association :likable, :factory => :post
    end
    
    factory :comment_like, :traits => [:for_comment]
    factory :post_like, :traits => [:for_post]
  end
end
