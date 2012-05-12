class Following < ActiveRecord::Base
  attr_accessible :followed_user_id
  
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
  
  validates :follower, :followed_user, presence: true
  validates :follower_id, :uniqueness => { :scope => [:followed_user_id] }
  validates :follower, exclusion: { in: proc(&:unavailable_users) }
  
  def unavailable_users
    [followed_user]
  end
end