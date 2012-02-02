class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :state_id
      t.belongs_to :user
      t.timestamps
    end
  end
end
