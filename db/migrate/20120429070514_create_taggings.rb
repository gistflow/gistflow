class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :taggable, polymorphic: true
      t.references :tag
    end
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :taggings, [:taggable_type, :taggable_id, :tag_id], unique: true
  end
end
