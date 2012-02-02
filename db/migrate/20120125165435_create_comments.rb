class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.boolean :question, :default => false
      t.text :body
      t.belongs_to :user
      t.belongs_to :post
      t.timestamps
    end
  end
end
