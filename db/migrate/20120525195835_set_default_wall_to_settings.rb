class SetDefaultWallToSettings < ActiveRecord::Migration
  def change
    change_column :settings, :default_wall, :string, default: 'flow'
  end
end
