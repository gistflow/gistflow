FactoryGirl.define do
  factory :user, :aliases => [:author, :commenter] do
    name { "Mad Max" }
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@gistflow.com" }
  end
end
