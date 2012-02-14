module Models
  module Likable
    extend ActiveSupport::Concern
    
    def liked_by_user?(user)
      Like.where(
        :likable_id   => id,
        :likable_type => self.class.name,
        :user_id      => user_id
      ).exists?
    end

    def likes
      Like.where(:likable_id => id, :likable_type => self.class.name)
    end
  end
end