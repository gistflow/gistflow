class MapsController < ApplicationController
  def show
    user_ids = []
    @locations = Location.ready.group_by do |location|
      user_ids << location.locationable_id
      [location.lat, location.lng]
    end
    users = Hash[User.find(user_ids).to_a.map { |u| [u.id, u] }]
    @locations = @locations.to_a.map do |positions, locations|
      { count: locations.size,
        users: locations.map { |l| users[l.locationable_id].username },
        lat: positions[0],
        lng: positions[1] }
    end
  end
end
