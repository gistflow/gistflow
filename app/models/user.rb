class User < ActiveRecord::Base
  include Models::Likable
  include Models::Memorizable
  
  has_many :account_cookies, :class_name => 'Account::Cookie'
  has_many :posts
  has_many :likes
  has_many :comments
  has_many :notifications
  has_many :subscriptions
  has_many :tags, :through => :subscriptions
  
  validates :username, :name, :presence => true
  validates :username, :uniqueness => true
  
  def create_cookie_secret
    account_cookies.create! do |cookie|
      cookie.generate_secret!
    end.secret
  end
  
  def github_gists
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
end
