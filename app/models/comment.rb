class Comment < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  
  belongs_to :user
  belongs_to :post, :counter_cache => true
  has_many :notifications, :as => :notifiable
  
  validates :content, :user, :presence => true
  
  attr_accessible :content, :question
  
  def body
    content
  end
end
