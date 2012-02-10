class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :tag
    end
    
    add_index :subscriptions, [:tag_id, :user_id], :unique => true
  end
end
