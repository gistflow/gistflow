FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "tag_#{n}" }
    posts_count 0
  end
end
