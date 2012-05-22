class AddDeletedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :deleted_at, :timestamp
  end
end
