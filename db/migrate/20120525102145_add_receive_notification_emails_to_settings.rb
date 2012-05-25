class AddReceiveNotificationEmailsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :receive_notification_emails, :boolean, default: true
  end
end