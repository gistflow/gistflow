FactoryGirl.define do
  factory :following do
    association :follower, :factory => :user
    association :followed_user, :factory => :user
  end
end