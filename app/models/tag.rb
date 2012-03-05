class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  validates :name, :presence => true
  
  scope :popular, (lambda do |limit = 100|
    order('posts_count desc').limit(limit)
  end)
end
