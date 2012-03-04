class CreateKits < ActiveRecord::Migration
  def change
    create_table :kits do |t|
      t.string :name
      t.integer :position, :default => 0
      t.integer :group_position
      t.integer :tags_count, :default => 0
    end
    
    add_index :kits, [:group_position, :position], :unique => true
  end
end
