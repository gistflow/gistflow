class User < ActiveRecord::Base
  include Models::Todolistable

  delegate :token, to: :account_token

  has_one  :account_github, class_name: 'Account::Github'
  has_one  :settings
  has_one  :profile
  has_one  :account_token, class_name: 'Account::Token'
  has_one  :location, as: :locationable
  has_many :posts
  has_many :likes
  has_many :comments
  has_many :notifications
  has_many :subscriptions
  has_many :likes
  has_many :bookmarks
  has_many :tags, through: :subscriptions
  has_many :observings
  has_many :followings, foreign_key: :follower_id, dependent: :destroy
  has_many :reverse_followings, foreign_key: :followed_user_id, class_name: :'Following'
  has_many :followed_users, through: :followings, source: :followed_user
  has_many :followers, through: :reverse_followings

  validates :username, :name, presence: true
  validates :username, uniqueness: true

  default_scope order: 'users.id asc'

  before_create :assign_settings
  before_create :assign_profile
  before_create :assign_token
  attr_accessor :company, :github_page, :home_page, :email

  conditions = {
    profiles: { email_valid: true },
    settings: { receive_notification_emails: true }
  }
  scope :mailable, joins(:profile, :settings).where(conditions)

  def self.gistflow
    User.where(username: 'gistflow').first_or_create! do |user|
      user.name = 'Gistflow'
    end
  end

  def self.find_by_token(token)
    Account::Token.find_by_token(token).user
  end

  def cache_key(type)
    "user:#{id}:#{type}"
  end

  def flow
    tag_ids = subscriptions.select(:tag_id).to_sql
    user_ids = followings.select(:followed_user_id).to_sql
    conditions = []
    conditions << "posts.user_id = #{id}"
    conditions << "taggings.tag_id in (#{tag_ids}) and posts.is_private = 'f'"
    conditions << "posts.user_id in (#{user_ids}) and posts.is_private = 'f'"
    Post.joins(:taggings).where(conditions.join(' or ')).uniq
  end

  # Bookmarks

  def bookmark? post
    bookmarks.where(post_id: post.id).exists?
  end

  def bookmark post
    bookmarks.where(post_id: post.id).first_or_create!
  end

  def unbookmark post
    bookmarks.where(post_id: post.id).destroy_all
  end

  def bookmarked_posts
    Post.joins(:bookmarks).where(bookmarks: { user_id: id })
      .reorder('bookmarks.id desc')
  end

  # Observings

  def observe? post
    observings.where(post_id: post.id).exists?
  end

  def observe post
    observings.where(post_id: post.id).first_or_create!
  end

  def unobserve post
    observings.where(post_id: post.id).destroy_all
  end

  # Followings

  def follow? user
    followings.where(followed_user_id: user.id).exists?
  end

  def follow user
    followings.where(followed_user_id: user.id).first_or_create!
  end

  def unfollow user
    followings.where(followed_user_id: user.id).destroy_all
  end

  # Likes

  def like? post
    likes.find { |like| like.post_id == post.id }
  end

  def like post
    likes.where(post_id: post.id).first_or_create!
  end

  def unlike post
    likes.where(post_id: post.id).destroy_all
  end

  # Subscriptions

  def subscribe? tag
    subscriptions.where(tag_id: tag.id).exists?
  end

  def subscribe tag
    subscriptions.where(tag_id: tag.id).first_or_create!
  end

  def unsubscribe tag
    subscriptions.where(tag_id: tag.id).destroy_all
  end

  def to_param
    username
  end

  def to_s
    username
  end

  def newbie?
    tags.empty? && followed_users.empty?
  end

  def github_gists(use_cache = true)
    Github::User.new(username).gists
  end

  def gravatar(size = 50)
    if gravatar_id
      "http://www.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
    else
      "http://www.gravatar.com/avatar/?size=#{size}"
    end
  end

  def mark_notifications_read
    notifications.unread.update_all read: true
  end

  def admin?
    username? && Rails.application.config.admins.include?(username)
  end

  def subscribe tag
    Subscription.find_or_create_by_user_id_and_tag_id(self.id, tag.id)
  end

  def oauth_token
    account_github.try(:token)
  end

private

  def assign_settings
    build_settings
  end

  def assign_profile
    build_profile do |p|
      p.company = company
      p.home_page = home_page
      p.email = email
    end
  end

  def assign_token
    build_account_token do |token|
      token.token = Digest::SHA1.hexdigest(rand.to_s)
    end
  end
end
