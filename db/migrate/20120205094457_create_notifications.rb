class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.integer :notifiable_id
      t.string :notifiable_type
      t.boolean :read, :default => false

      t.timestamps
    end
    
    add_index :notifications, [:user_id, :notifiable_id, :notifiable_type], :unique => true, :name => :notifications_users_notifiables
  end
end
