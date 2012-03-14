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
  validates :preview, :length => 3..500
  
  attr_accessible :title, :content
  
  class << self
    def constantize(type)
      if ['Post::Gossip', 'Post::Article', 'Post::Question'].include?(type)
        type.constantize
      else
        raise "unknown type \"#{type}\""
      end
    end
    
    def search(text)
      doc_ids = index.search(text)['results'].map do |doc|
        doc['docid']
      end
      find(docid)
    end
    
    def index
      @@index ||= $indextank.indexes('postsx')
    end
  end
  
  def short_class_name
    self.class.name.underscore.split('/').last
  end
  
  def link_name
    ln = title.blank? ? preview : title
    ln[0..30].strip
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
    if content.blank?
      0
    elsif content == '<cut>'
      1
    else
      content.split('<cut>').size - 1
    end
  end
  
  def content_parts
    @content_parts ||= content.to_s.split('<cut>', 2)
  end
end
