class Following < ActiveRecord::Base
  attr_accessible :followed_user_id
  
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
  
  validates :follower_id, :followed_user_id, presence: true
  validates :follower_id, :uniqueness => { :scope => [:followed_user_id] }  
end
