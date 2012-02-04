module Likable
  def liked_by_user?(user)
    Like.where(:likable_id => self.id, :likable_type => self.class.name, :user_id => user.id).exists?
  end
  
  def likes
    Like.where(:likable_id => self.id, :likable_type => self.class.name)
  end
end