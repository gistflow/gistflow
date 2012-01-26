class User < ActiveRecord::Base
  
  has_one :github_account, :class_name => "Account::Github", :foreign_key => "user_id", :dependent => :destroy
  has_many :posts
  
  def github_gists
    Github::User.new(username).gists
  end
end
