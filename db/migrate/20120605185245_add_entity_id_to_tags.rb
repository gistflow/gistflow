class AddEntityIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :entity_id, :integer
    add_index :tags, :entity_id
  end
end
