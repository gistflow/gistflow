class Like < ActiveRecord::Base
  
  LIKABLE_TYPES = ["Post::Article", "Post::Question", "Post:Community", "Comment"]
  
  belongs_to :user
  belongs_to :likable, :polymorphic => true
  
  validates :likable_type, :inclusion => { :in => LIKABLE_TYPES }
  validates :user_id, :uniqueness => { :scope => [:likable_id, :likable_type] }
  validates :user, :exclusion => { :in => proc(&:unavailable_users) }

  def unavailable_users
    [likable.user]
  end
end
