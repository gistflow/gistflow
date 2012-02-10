class Post < ActiveRecord::Base
  attr_accessor :title, :preview, :body
  include Replaceable::Taggable
  include Replaceable::Mentionable
  include Replaceable::Gistable
  include Likable
  include Notifiable
  include Taggable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  has_many :comments
  has_many :likes, :as => :likable
  has_and_belongs_to_many :lovers, :class_name => "User",
    :join_table => :favorite_posts_lovers
  
  default_scope :order => 'created_at desc'
  
  validates :content, :user, :presence => true
  
  attr_accessor :tag_names
  attr_accessible :content, :title, :preview, :body, :tag_names
  
  
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
  
protected
  
  def build_content
    write_attribute :content, [title, preview, body].join("\n\n")
  end
end
