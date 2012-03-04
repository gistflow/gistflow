class CreateUsersKits < ActiveRecord::Migration
  def change
    create_table :users_kits, :id => false do |t|
      t.integer :user_id
      t.integer :kit_id
    end
    
    add_index :users_kits, :user_id
    add_index :users_kits, [:user_id, :kit_id], :unique => true
  end
end
