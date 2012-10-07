class Notification < ActiveRecord::Base
  default_scope order: 'created_at desc'
  
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [:notifiable_id, :notifiable_type, :type] }
  validates :user, :type, :notifiable, presence: true
  
  scope :read, where(read: true)
  scope :unread, where(read: false)
  
  after_commit :create_mailer_task, on: :create
  after_commit :push_to_redis, on: :create
  
  delegate :host, to: :'Rails.application.config'
  
private
  
  def create_mailer_task
    if self.user.profile.email_valid? &&
      self.user.settings.receive_notification_emails?
      Resque.enqueue(Mailer, 'UserMailer', :notification_email, self.id)
    end
    true
  end
  
  def push_to_redis
    $redis.publish("notifications:#{user.token}", title)
    true
  end
end