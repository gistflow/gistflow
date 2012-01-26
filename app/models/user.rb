class User < ActiveRecord::Base
  
  has_one :github_account, :class_name => "Account::Github", :foreign_key => "user_id", :dependent => :destroy
  has_many :posts
  
  def gists
    self.github_account.get_gists
  end
end
