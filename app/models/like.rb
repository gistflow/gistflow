class Like < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :post, counter_cache: true
  
  validates :user, :post, presence: true
end
