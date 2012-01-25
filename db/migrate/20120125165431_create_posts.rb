class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :state
      t.references :user
      t.timestamps
    end
  end
end
