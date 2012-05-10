class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :post
      t.references :user
    end
    
    add_index :bookmarks, :post_id
    add_index :bookmarks, :user_id
    add_index :bookmarks, [:post_id, :user_id], unique: true
  end
end
