class Notification < ActiveRecord::Base
  default_scope order: 'created_at desc'
  
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [:notifiable_id, :notifiable_type, :type] }
  validates :user, :type, :notifiable, presence: true
  
  scope :read, where(notifications: { read: true })
  scope :unread, where(notifications: { read: false })
  scope :todays, where("DATE(notifications.created_at) = DATE(?)", Time.now)
  
  scope :for_daily_reports, joins(user: [:settings, :profile]).where(
    settings: { recieve_daily_reports: true },
    profiles: { email_valid: true }
  )
end