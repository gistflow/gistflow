class Location < ActiveRecord::Base
  belongs_to :locationable, polymorphic: true  

  validates :locationable_id, :locationable_type, :address, presence: true
  validates_uniqueness_of :locationable_id, scope: :locationable_type
  
  scope :with_coordinates, where("lat is not null and lng is not null")
  
  geocoded_by :address, latitude: :lat, longitude: :lng
  before_save :geocode
  
  attr_accessible :address
  
  def self.to_map
    user_ids = []
    locations = scoped.where(locationable_type: :User).group_by do |location|
      user_ids << location.locationable_id
      [location.lat, location.lng]
    end
    users = Hash[User.find(user_ids).to_a.map { |u| [u.id, u] }]
    locations.to_a.map do |positions, locations|
      { count: locations.size,
        users: locations.map { |l| users[l.locationable_id].username },
        lat: positions[0],
        lng: positions[1] }
    end
  end
end