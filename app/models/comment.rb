class Comment < ActiveRecord::Base
  include Models::Likable
  include Models::Taggable
  include Models::Mentionable
  
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_many :notifications, {
    as:         :notifiable,
    dependent:  :destroy,
    class_name: 'Notification::Comment'
  }
  
  validates :content, :user, presence: true
  
  attr_accessible :content, :question
  
  after_create :observe_post_to_author
  after_create :notify_observing
  
  def body
    content
  end
  
protected
  
  def observe_post_to_author
    user.observe(post)
    true
  end
  
  def notify_observing
    post.observings.includes(:user).each do |observing|
      next if observing.user_id == user_id
      
      notifications.create! do |notification|
        notification.user = observing.user
      end
    end
  end
end
