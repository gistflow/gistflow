class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :posts_count, :default => 0
    end
    
    add_index :tags, :name, :unique => true
  end
end
