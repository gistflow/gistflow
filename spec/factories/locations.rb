FactoryGirl.define do
  factory :location do
    lat { rand + rand(50) }
    lng { rand + rand(50) }
    association :locationable, factory: :user
    address { Faker::Address.city }
  end
end