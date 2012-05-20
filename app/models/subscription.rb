class Subscription < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :tag
  
  validates :user, :tag, presence: true
end