class User < ActiveRecord::Base
  has_many :account_cookies, :class_name => 'Account::Cookie'
  has_many :posts
  has_many :comments, :foreign_key => :author_id
  has_many :answer_comments, :class_name => "Comment", :foreign_key => :consignee_id  
  has_and_belongs_to_many :favorite_posts, :class_name => "Post", 
    :join_table => :favorite_posts_lovers
  
  validates :username, :name, :email, :presence => true
  validates :username, :email, :uniqueness => true
  
  def create_cookie_secret
    account_cookies.create! do |cookie|
      cookie.generate_secret!
    end.secret
  end
  
  def github_gists
    []
  end
end
