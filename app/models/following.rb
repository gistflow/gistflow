class Following < ActiveRecord::Base
  attr_accessible :followed_user_id
  
  belongs_to :follower, class_name: 'User', touch: true
  belongs_to :followed_user, class_name: 'User'
  
  validates :follower, :followed_user, presence: true
  validates :follower_id, :uniqueness => { :scope => [:followed_user_id] }
  validates :follower, exclusion: { in: proc(&:unavailable_users) }
  
  has_many :notifications, {
    as:         :notifiable,
    dependent:  :destroy,
    class_name: 'Notification::Following'
  }
  
  after_create :notify_followed_user
  
  def unavailable_users
    [followed_user]
  end
  
protected
  
  def notify_followed_user
    notifications.create! do |notification|
      notification.user = followed_user
    end
  end
end