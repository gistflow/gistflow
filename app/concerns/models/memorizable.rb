module Models
  module Memorizable
    extend ActiveSupport::Concern
    
    def memorized?(post)
      $redis.sismember redis_key, post.id
    end
    
    def memorize(post)
      $redis.sadd redis_key, post.id
    end
    
    def forgot(post)
      $redis.srem redis_key, post.id
    end
    
    def remembrance
      Post.where(:id => ($redis.smembers redis_key))
    end
    
  protected

    def redis_key
      "remembrance:#{id}"
    end
  end
end