class MapsController < ApplicationController
  def show
    @locations = Location.includes(:locationable)
  end
end
