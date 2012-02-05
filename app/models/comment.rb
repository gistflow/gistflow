class Comment < ActiveRecord::Base
  include Likable
  
  include Notifiable
  
  belongs_to :user
  belongs_to :post, :counter_cache => true
  
  has_many :notifications, :as => :notifiable
  
  validates :body, :presence => true
  
  def content
    body
  end
end
