class Comment < ActiveRecord::Base
  include Likable
  include Notifiable
  include Replaceable::Taggable
  include Replaceable::Mentionable
  include Replaceable::Gistable
  
  belongs_to :user
  belongs_to :post, :counter_cache => true
  has_many :notifications, :as => :notifiable
  
  validates :content, :user, :presence => true
  
  attr_accessible :content, :question
  
  def body
    content
  end
end
