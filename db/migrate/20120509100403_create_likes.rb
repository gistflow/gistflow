class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user
      t.references :post
    end
    
    add_index :likes, :user_id
    add_index :likes, :post_id
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
