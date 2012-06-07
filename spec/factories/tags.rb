FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "tag_#{n}" }
    
    factory :tag_alias do
      association :entity, factory: :tag
    end
  end
end
