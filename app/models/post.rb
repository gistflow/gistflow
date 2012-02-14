class Post < ActiveRecord::Base
  attr_accessor :title, :preview, :body
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
  
  attr_accessible :content, :title, :preview, :body
  
  class << self
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
    content[0..30]
  end
  
protected
  
  def build_content
    write_attribute :content, [title, preview, body].join("\n\n")
  end
end
