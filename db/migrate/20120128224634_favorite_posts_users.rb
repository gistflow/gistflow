class FavoritePostsUsers < ActiveRecord::Migration  
  def self.up
    create_table :favorite_posts_lovers, :id => false do |t|
        t.integer :post_id
        t.integer :user_id
    end
    add_index :favorite_posts_lovers, [:post_id, :user_id], :unique => true
  end

  def self.down
    drop_table :favorite_posts_lovers
  end
end
