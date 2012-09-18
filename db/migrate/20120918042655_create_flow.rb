class CreateFlow < ActiveRecord::Migration
  def change
    create_table :flow do |t|
      t.integer :user_id
      t.integer :post_id
    end
    
    add_index :flow, :user_id
    add_index :flow, :post_id
    add_index :flow, [:user_id, :post_id], unique: true
  end
end
