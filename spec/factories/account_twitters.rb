FactoryGirl.define do
  factory :account_twitter, :class => 'Account::Twitter' do
    token '123'
    secret '12312'
    sequence(:twitter_id) { |n| n }
    user
  end
end
