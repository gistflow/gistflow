class AddTypeToUniqueNotificationsIndex < ActiveRecord::Migration
  def change
    remove_index :notifications, name: :notifications_users_notifiables
    add_index :notifications, [:user_id, :notifiable_id, :notifiable_type, :type], {
      unique: true,
      name:   :notifications_users_notifiables
    }
  end
end
