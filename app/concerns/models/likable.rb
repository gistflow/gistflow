module Models
  module Likable
    extend ActiveSupport::Concern
    
    def liked_by?(user)
      $redis.sismember redis_key, user.id
    end
        
    def likes_count
      $redis.scard redis_key
    end
    
    def like(record)
      if record.user != self
        $redis.sadd(record.redis_key, id)
      else
        false
      end
    end
    
    def redis_key
      "likes:#{id}:Post"
    end
  end
end