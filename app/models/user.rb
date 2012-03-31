class User < ActiveRecord::Base
  include Models::Likable
  include Models::Memorizable
  
  has_many :account_cookies, :class_name => 'Account::Cookie'
  has_many :posts
  has_many :articles, :class_name => 'Post::Article'
  has_many :questions, :class_name => 'Post::Question'
  has_many :gossips, :class_name => 'Post::Gossip'
  has_many :likes
  has_many :comments
  has_many :notifications
  has_many :subscriptions
  has_many :tags, :through => :subscriptions
  
  validates :username, :name, :presence => true
  validates :username, :uniqueness => true
  
  after_create :send_welcome_email
  
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
    notifications.unread.update_all(:read => true)
  end
  
  def admin?
    username? && Rails.application.config.admins.include?(username)
  end
  
private
  
  def send_welcome_email
    UserMailer.welcome_email(id).deliver if email
  end
end
