class User < ActiveRecord::Base
  
  LIKABLE_TYPES = ["Post::Article", "Post::Question", "Post:Community", "Comment"]
  
  has_many :account_cookies, :class_name => 'Account::Cookie'
  has_many :posts
  has_many :likes
  has_many :comments
  has_and_belongs_to_many :favorite_posts, :class_name => "Post", 
    :join_table => :favorite_posts_lovers
  
  validates :username, :name, :presence => true
  validates :username, :uniqueness => true
  
  def create_cookie_secret
    account_cookies.create! do |cookie|
      cookie.generate_secret!
    end.secret
  end
  
  def like(record)
    likes.create(
      :likable_id => record.id, 
      :likable_type => record.type
    ) if LIKABLE_TYPES.include?(record.type)
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
end
