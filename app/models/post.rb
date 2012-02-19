class Post < ActiveRecord::Base
  attr_accessor :title, :preview, :body
  include Models::Likable
  include Models::Notifiable
  include Models::Taggable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  has_many :comments
  
  default_scope :order => 'created_at desc'
  
  validates :content, :user, :presence => true
  
  attr_accessible :content, :title, :preview, :body
  
  class << self
    def constantize(type)
      if ['Post::Community', 'Post::Article', 'Post::Question'].include?(type)
        type.constantize
      else
        raise "unknown type \"#{type}\""
      end
    end
    
    def search(query)
      query.strip!
      case query[0]
      when '#' then
        tagged_with query[1..-1]
      when '@' then
        joins(:user).where(:users => { :username => query[1..-1] }).uniq
      else
        where "content like :q", :q => "%#{query}%"
      end
    end
  end
  
  def title=(text)
    @title = text.strip
    build_content
  end
  
  def preview=(text)
    @preview = text.strip
    build_content
  end
  
  def body=(text)
    @body = text.strip
    build_content
  end
  
  def link_name
    "#{content[0..30].strip}.."
  end
  
protected
  
  def build_content
    write_attribute :content, [title, preview, body].join("\n\n")
  end
end
