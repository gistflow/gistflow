class SetDefaultWallToAll < ActiveRecord::Migration
  def change
    change_column :settings, :default_wall, :string, default: 'all'
  end
end