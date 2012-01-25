FactoryGirl.define do
  factory :account_github, :class => Account::Github do
    user
    sequence(:token) { |n| "token_#{n}" }
    sequence(:github_id) { |n| n }
  end
end
