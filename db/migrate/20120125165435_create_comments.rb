class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :type
      t.references :post, :polymorphic => true
      t.boolean :question
      t.integer :author_id
      t.integer :consignee_id
      t.text :body
      t.timestamps
    end
  end
end
