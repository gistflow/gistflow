class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :default_wall

      t.timestamps
    end
  end
end
