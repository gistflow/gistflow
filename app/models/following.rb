class Following < ActiveRecord::Base
  attr_accessible :followed_user_id
  
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
  
  validates :follower, :followed_user, presence: true
  validates :follower_id, :uniqueness => { :scope => [:followed_user_id] }
  validate :self_following
  
  has_many :notifications, {
    as:         :notifiable,
    dependent:  :destroy,
    class_name: 'Notification::Following'
  }
  
  after_create :notify_followed_user
  
  protected
  def self_following 
    errors.add :follower_id, 'Can not follow yourself' if followed_user_id == follower_id
  end
  
  def notify_followed_user
    notifications.create! do |notification|
      notification.user = followed_user
    end
  end
end