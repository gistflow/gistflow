class MapsController < ApplicationController
  def show
    @locations = Location.with_coordinates.to_map
  end
end
