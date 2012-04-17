class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :comments_count, :default => 0
      t.integer :likes_count, :default => 0
      t.string :title
      t.text :content
      t.integer :state_id
      t.belongs_to :user
      t.string :type
      t.timestamps
    end
  end
end
