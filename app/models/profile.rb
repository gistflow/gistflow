class Profile < ActiveRecord::Base
  attr_accessible :company, :email, :home_page
  
  belongs_to :user
end