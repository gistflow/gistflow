class User < ActiveRecord::Base
  validates :username, :name, :email, :presence => true
  validates :username, :email, :uniqueness => true
end
