class AddIndexesForWikis < ActiveRecord::Migration
  def change
    add_index :wikis, [:id, :tag_id]
  end
end
