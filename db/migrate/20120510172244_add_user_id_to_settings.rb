class AddUserIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :user_id, :integer
    add_index :settings, :user_id, :unique => true
  end
end