class Flow < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  validates :user, :post, presence: true
end
