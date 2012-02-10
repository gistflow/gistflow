class CreateFrameworks < ActiveRecord::Migration
  def change
    create_table :frameworks do |t|
      t.string :name
      t.integer :language_id

      t.timestamps
    end
  end
end
