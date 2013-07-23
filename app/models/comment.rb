class Comment < ActiveRecord::Base
  include Models::Taggable
  include Models::Mentionable
  include Models::Indestructible

  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true
  has_many :notifications, {
    as:         :notifiable,
    class_name: 'Notification::Comment'
  }

  has_many :mention_notifications, {
    as:         :notifiable,
    class_name: 'Notification::Mention'
  }

  validates :content, :user, presence: true

  attr_accessible :content

  after_create :observe_post_to_author
  after_create :notify_observing

  def body
    content
  end

  # called after mark_deleted
  def decrement_counters
    Post.decrement_counter(:comments_count, post_id)
  end

protected

  def observe_post_to_author
    user.observings.create do |observing|
      observing.post = post
    end
    true
  end

  def notify_observing
    mentioned_user_ids = mention_notifications.pluck(:user_id)
    mentioned_user_ids << user_id

    post.observings.where('observings.user_id NOT IN (?)', mentioned_user_ids).includes(:user).each do |observing|
      notifications.create! do |notification|
        notification.user = observing.user
      end
    end
  end
end
