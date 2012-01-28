class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :type
      t.text :body
      t.integer :author_id
      t.integer :consignee_id
      t.belongs_to :post
      t.timestamps
    end
  end
end
