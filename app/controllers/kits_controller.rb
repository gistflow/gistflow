class KitsController < ApplicationController
  def index
    @kits = Kit.includes(:user_kits).sorted.group_by(&:group_position)
  end
end
