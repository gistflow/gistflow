class User < ActiveRecord::Base
  has_many :account_cookies, :class_name => 'Account::Cookie'
  has_many :comments, :foreign_key => :author_id
  has_many :answer_comments, :class_name => "Comment", :foreign_key => :consignee_id
  
  validates :username, :name, :email, :presence => true
  validates :username, :email, :uniqueness => true
  
  def create_cookie_secret
    account_cookies.create! do |cookie|
      cookie.generate_secret!
    end.secret
  end
end
