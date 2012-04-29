class Comment < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  belongs_to :post, :counter_cache => true
  
  validates :content, :user, :presence => true
  
  attr_accessible :content, :question
  
  def body
    content
  end
end
