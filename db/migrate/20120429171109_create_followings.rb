class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :followed_user_id

      t.timestamps
      
    end
    
    add_index :followings, :followed_user_id
    add_index :followings, :follower_id
    add_index :followings, [:followed_user_id, :follower_id], :unique => true
  end
end
