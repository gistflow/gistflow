FactoryGirl.define do
  factory :notification do
    user
    
    factory :comment_notification, class: 'Notification::Comment' do
      association :notifiable, factory: :comment
    end
    
    factory :mention_notification, class: 'Notification::Mention' do
      association :notifiable, factory: :comment
    end
    
    factory :following_notification, class: 'Notification::Following' do
      association :notifiable, factory: :following
    end
  end
end