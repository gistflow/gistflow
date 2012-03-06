class Post < ActiveRecord::Base
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  has_many :comments
  
  default_scope :order => 'id desc'
  
  validates :user, :presence => true
  validates :cuts_count, :inclusion => { :in => [0, 1] }
  validates :preview, :length => 3..160
  
  attr_accessible :title, :content
  
  class << self
    def constantize(type)
      if ['Post::Gossip', 'Post::Article', 'Post::Question'].include?(type)
        type.constantize
      else
        raise "unknown type \"#{type}\""
      end
    end
  end
  
  def short_class_name
    self.class.name.underscore.split('/').last
  end
  
  def link_name
    "#{body[0..30].strip}.."
  end
  
  def controller
    self.class.name.underscore.pluralize
  end
  
  def preview
    content_parts.first.to_s.strip
  end
  
  def body
    content.to_s.gsub('<cut>', "\r\n")
  end
  
protected
  
  def cuts_count
    content.split('<cut>').size - 1
  end
  
  def content_parts
    @content_parts ||= content.to_s.split('<cut>', 2)
  end
end
