class User < ActiveRecord::Base
  has_many :account_cookies, class_name: :'Account::Cookie'
  has_one  :account_twitter, class_name: :'Account::Twitter'
  has_many :posts
  has_many :likes
  has_many :comments
  has_many :notifications
  has_many :subscriptions
  has_many :likes
  has_many :bookmarks
  has_many :bookmarked_posts, through: :bookmarks, class_name: :'Post'
  has_many :tags, through: :subscriptions
  has_many :observings
  has_many :followings, foreign_key: :follower_id, dependent: :destroy
  has_many :reverse_followings, foreign_key: :followed_user_id, class_name: :'Following'
  has_many :followed_users, through: :followings, source: :followed_user
  has_many :followers, through: :reverse_followings
  
  validates :username, :name, presence: true
  validates :username, uniqueness: true
  
  after_create :send_welcome_email
  
  def intrested_posts
    Post.joins(tags: { subscriptions: :user }).where(users: { id: id }).uniq
  end
  
  def bookmark?(post)
    Rails.logger.info bookmarks.inspect
    Rails.logger.info post.inspect
    Rails.logger.info bookmarks.find { |bookmark| bookmark.post_id == post.id }.inspect
    bookmarks.find { |bookmark| bookmark.post_id == post.id }
  end
  
  def observe?(post)
    observings.find { |observing| observing.post_id == post.id }
  end
  
  def follow?(user)
    followings.find { |following| following.followed_user_id = user.id }
  end
  
  def like?(post)
    likes.find { |like| like.post_id == post.id }
  end
  
  # def observed
  #   Post.joins(:observings).where(observings: { user_id: id })
  # end
  # 
  # def observe(post)
  #   observings.where(post_id: post.id).first_or_create!
  # end
  
  def to_param
    username
  end
  
  def to_s
    username
  end
  
  def newbie?
    tags.count < 3
  end
  
  def contacts
    Hash[begin
      { 'Name'        => name,
        'Github Page' => github_page,
        'Company'     => company,
        'Email'       => email,
        'Home page'   => home_page }.find_all do |field, value|
        value.present?
      end
    end]
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
  
  def followed_posts
    Post.followed_by(self)
  end
  
private
  
  def send_welcome_email
    UserMailer.welcome_email(id).deliver if email?
  end
end
