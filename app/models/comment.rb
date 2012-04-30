class Comment < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  belongs_to :post, counter_cache: true
  
  validates :content, :user, presence: true
  
  attr_accessible :content, :question
  
  after_create :observe_post_to_author
  
  def body
    content
  end
  
protected
  
  def observe_post_to_author
    user.observe(post)
    true
  end
end
