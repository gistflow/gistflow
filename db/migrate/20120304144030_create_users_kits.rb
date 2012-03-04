class CreateUsersKits < ActiveRecord::Migration
  def change
    create_table :user_kits do |t|
      t.integer :user_id
      t.integer :kit_id
    end
    
    add_index :user_kits, :user_id
    add_index :user_kits, [:user_id, :kit_id], :unique => true
  end
end
