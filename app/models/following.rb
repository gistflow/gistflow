class Following < ActiveRecord::Base
  attr_accessible :followed_user_id
  
  belongs_to :follower, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
  
  validates :follower_id, :followed_user_id, presence: true
  validates :follower_id, :uniqueness => { :scope => [:followed_user_id] }
  validate :self_following
  
  protected
  def self_following 
    errors.add :follower_id, 'Can not follow yourself' if followed_user_id == follower_id
  end
end