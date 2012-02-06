class Post < ActiveRecord::Base
  include Replaceable::Mentionable
  include Replaceable::Gistable
  include Notifiable
  
  belongs_to :user
  has_many :comments
  has_many :notifications, :as => :notifiable
  
  has_and_belongs_to_many :lovers, :class_name => "User",
    :join_table => :favorite_posts_lovers
  
  has_many :comments
  has_many :likes, :as => :likable
  
  default_scope :order => 'created_at DESC'
  
  validates :content, :user, :presence => true
end
