class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :account_githubs, :user_id
    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index :gists, :user_id
    add_index :gists, [:source_id, :source_type]
    add_index :posts, :user_id
    add_index :wikis, :user_id
  end
end
