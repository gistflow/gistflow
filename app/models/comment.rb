class Comment < ActiveRecord::Base
  include Likable
  include Notifiable
  
  belongs_to :user
  belongs_to :post, :counter_cache => true
  has_many :notifications, :as => :notifiable
  
  validates :content, :user, :presence => true
  
  attr_accessible :content, :question
end
