class Account::Github < ActiveRecord::Base
  
  belongs_to :user
  
end
