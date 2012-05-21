class Notification < ActiveRecord::Base
  default_scope order: 'created_at desc'
  
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [:notifiable_id, :notifiable_type, :type] }
  validates :user, :type, :notifiable, presence: true
  
  scope :read, where(read: true)
  scope :unread, where(read: false)
  
  after_commit :create_mailer_task
  
  delegate :host, to: :'Rails.application.config'
  
  protected
  def create_mailer_task
    if self.user.profile.email_valid?
      Resque.enqueue(Mailer, 'UserMailer', :notification_email, self.id)
    end
  end
end