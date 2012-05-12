class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  validates :user, :post, presence: true
  
  attr_accessible :post_id
end
