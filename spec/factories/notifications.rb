# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user

    trait :for_comment do
      association :notifiable, :factory => :comment
    end

    trait :for_post do
      association :notifiable, :factory => :post
    end

    factory :comment_notification, :traits => [:for_comment]
    factory :post_notification, :traits => [:for_post]
  end
end
