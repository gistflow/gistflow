class Location < ActiveRecord::Base
  belongs_to :locationable, polymorphic: true  

  validates :locationable_id, :locationable_type, :address, presence: true
  validates_uniqueness_of :locationable_id, scope: :locationable_type

  geocoded_by :address, latitude: :lat, longitude: :lng
  before_save :geocode
  
  attr_accessible :address
end