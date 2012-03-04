class UserKit < ActiveRecord::Base
  after_create :assign_user_tags
  
  belongs_to :user
  belongs_to :kit
  
  attr_accessible :kit_id
  
protected

  def assign_user_tags
    user.tag_ids = [user.tag_ids + kit.tag_ids].uniq
  end
end