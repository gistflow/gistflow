class CreateKitsTags < ActiveRecord::Migration
  def change
    create_table :kits_tags, :id => false do |t|
      t.integer :kit_id
      t.integer :tag_id
    end
    
    add_index :kits_tags, :kit_id
    add_index :kits_tags, :tag_id
    add_index :kits_tags, [:kit_id, :tag_id], :unique => true
  end
end
