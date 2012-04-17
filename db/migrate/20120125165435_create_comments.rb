class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.boolean :question, :default => false
      t.text :content
      t.belongs_to :user
      t.belongs_to :post
      t.integer :likes_count, :default => 0
      t.timestamps
    end
  end
end
