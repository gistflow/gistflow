class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, :counter_cache => true
  
  has_many :likes, :as => :likable
  
  validates :body, :presence => true  
end
