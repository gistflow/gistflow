class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.references :tag
      t.references :user
      t.text :content
      t.timestamp :created_at
    end
  end
end
