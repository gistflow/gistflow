class CreateTimeCounters < ActiveRecord::Migration
  def change
    create_table :time_counters do |t|
      t.string :model
      t.integer :total_count
      t.integer :today_count
      t.date :date

      t.timestamps
    end

    add_index :time_counters, [:model, :date], unique: true
  end
end