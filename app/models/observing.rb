class Observing < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates :post, :user, presence: true
  validates :post_id, uniqueness: { scope: [:user_id] }
  
  attr_accessible :post_id
end
