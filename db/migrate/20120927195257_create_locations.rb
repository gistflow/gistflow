class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :lat
      t.float :lng
      t.integer :locationable_id
      t.string :locationable_type
      t.string :address, null: false

      t.timestamps
    end

    add_index :locations, :locationable_id
    add_index :locations, :locationable_type
    add_index :locations, [:locationable_id, :locationable_type], unique: true
  end
end