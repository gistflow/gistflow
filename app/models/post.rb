class Post < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  has_many :comments
  
  default_scope :order => 'id desc'
  
  validates :body, :user, :presence => true
  
  attr_accessible :title, :body
  
  class << self
    def constantize(type)
      if ['Post::Gossip', 'Post::Article', 'Post::Question'].include?(type)
        type.constantize
      else
        raise "unknown type \"#{type}\""
      end
    end
    
    def short_name
      self.class.name.underscore.split('/').last
    end
  end
  
  def link_name
    "#{content[0..30].strip}.."
  end
  
  def controller
    self.class.name.underscore.pluralize
  end
end
