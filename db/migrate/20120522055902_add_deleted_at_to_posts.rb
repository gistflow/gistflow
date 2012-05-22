class AddDeletedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :deleted_at, :timestamp
  end
end
