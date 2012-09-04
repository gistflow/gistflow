FactoryGirl.define do
  factory :time_counter do
    model 'Post'
    total_count { rand(300) }
    today_count { rand(30) }
    date { rand(10.years).ago.to_date }
  end
end