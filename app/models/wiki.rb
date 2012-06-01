class Wiki < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  attr_accessible :content
end
