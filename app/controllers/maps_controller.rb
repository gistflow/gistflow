class MapsController < ApplicationController
  def show
    @locations = Location.ready.to_map
  end
end
