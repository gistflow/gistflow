FactoryGirl.define do
  factory :cookie, :class => Account::Cookie do
    user
    sequence(:secret) { |n| "secret_#{n}" }
  end
end
