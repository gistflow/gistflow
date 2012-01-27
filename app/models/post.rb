class Post < ActiveRecord::Base
  belongs_to :user
  default_scope :order => 'created_at DESC'
  
end
