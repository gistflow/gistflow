class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  validates :user, :tag, presence: true
end