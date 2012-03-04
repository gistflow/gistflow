class KitsController < ApplicationController
  def index
    @kits = Kit.sorted
  end
end
