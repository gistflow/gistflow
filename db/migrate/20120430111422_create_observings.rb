class CreateObservings < ActiveRecord::Migration
  def change
    create_table :observings do |t|
      t.references :post
      t.references :user
    end
    
    add_index :observings, :post_id
    add_index :observings, :user_id
    add_index :observings, [:post_id, :user_id], unique: true
  end
end
