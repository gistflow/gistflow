class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  has_and_belongs_to_many :lovers, :class_name => "User",
    :join_table => :favorite_posts_lovers
  
  default_scope :order => 'created_at DESC'
  
  validates :title, :body, :presence => true
  validates :title, :length => 10..255
  validates :body, :length => { :minimum => 10 }
  
  def content
    body
  end
  
  def content=(content)
    self.body = content
    self.title = content.gsub(/\{gist:\d+\}/, '').gsub(/  /, '')[0..255]
  end
end
