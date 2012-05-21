FactoryGirl.define do
  factory :settings, :class => 'Settings' do
    user
    default_wall { Settings::WALLS[rand Settings::WALLS.size] }
  end
end