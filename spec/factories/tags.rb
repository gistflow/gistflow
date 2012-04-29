FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "tag_#{n}" }
  end
end
