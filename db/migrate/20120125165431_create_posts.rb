class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.integer :comments_count, :default => 0
      t.text :body
      t.string :state
      t.belongs_to :user
      t.timestamps
    end
  end
end
