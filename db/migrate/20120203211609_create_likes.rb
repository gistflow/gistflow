class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.belongs_to :user
      t.integer :likable_id
      t.string :likable_type

      t.timestamps
    end
    
    add_index :likes, [:user_id, :likable_id, :likable_type], :unique => true
  end  
end
