class KitsController < ApplicationController
  def index
    @kits = Kit.sorted.group_by(&:group_position)
  end
end
