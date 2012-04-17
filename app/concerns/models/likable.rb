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
      $redis.sadd record.redis_key, id
    end
    
    def redis_key
      "likes:#{id}:Post"
    end
  end
end