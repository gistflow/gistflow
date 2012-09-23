class Like < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :post, counter_cache: true
  
  validates :user, :post, presence: true
  
  after_create :increment_user_rating

private
  
  def increment_user_rating
    post.user.increment!(:rating)
  end
end
