class Post < ActiveRecord::Base
  include Replaceable::Mentionable
  include Replaceable::Gistable
  
  belongs_to :user
  
  has_and_belongs_to_many :lovers, :class_name => "User",
    :join_table => :favorite_posts_lovers
  
  has_many :comments
  has_many :likes, :as => :likable
  
  default_scope :order => 'created_at DESC'
  
  validates :content, :presence => true
  
  def title
    ''
  end
  
  def body
    ''
  end
  
  def preview
    ''
  end
end
