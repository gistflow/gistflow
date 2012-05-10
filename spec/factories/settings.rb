FactoryGirl.define do
  factory :settings, :class => 'Settings' do
    default_wall { Settings::WALLS[Settings::WALLS.size] }
  end
end
