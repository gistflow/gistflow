class User < ActiveRecord::Base
  has_many :account_cookies, class_name: :'Account::Cookie'
  has_one  :account_twitter, class_name: :'Account::Twitter'
  has_one  :settings
  has_one  :profile
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
  
  after_create :assign_settings, :assign_profile
  attr_accessor :company, :github_page, :home_page, :email
  
  def intrested_posts
    tag_ids = subscriptions.select(:tag_id).to_sql
    Post.joins(:taggings).where("taggings.tag_id in(#{tag_ids})").uniq
  end
  
  # For one join and bookrmarks ordering
  def bookmarked_posts
    Post.joins(:bookmarks).where(bookmarks: { user_id: id })
      .reorder('bookmarks.id desc')
  end
  
  def followed_posts
    Post.followed_by(self)
  end
  
  def bookmark?(post)
    bookmarks.find { |bookmark| bookmark.post_id == post.id }
  end
  
  def observe?(post)
    observings.find { |observing| observing.post_id == post.id }
  end
  
  def follow?(user)
    followings.find { |following| following.followed_user_id == user.id }
  end
  
  def like?(post)
    likes.find { |like| like.post_id == post.id }
  end
  
  def subscribe?(tag)
    subscriptions.find { |subscription| subscription.tag_id == tag.id }
  end
  
  def observed
    Post.joins(:observings).where(observings: { user_id: id })
  end
  
  def to_param
    username
  end
  
  def to_s
    username
  end
  
  def newbie?
    tags.count < 3
  end
  
  def create_cookie_secret
    account_cookies.create! do |cookie|
      cookie.generate_secret!
    end.secret
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
  
  def twitter_client?
    !!account_twitter
  end
  
  def twitter_client
    return unless twitter_client?
    
    @twitter_account ||= Twitter::Client.new(
      oauth_token: account_twitter.token,
      oauth_token_secret: account_twitter.secret
    )
  end
  
private
  
  def assign_settings
    create_settings
  end
  
  def assign_profile
    create_profile do |p|
      p.company = company
      p.home_page = home_page
      p.email = email
    end
  end
end
