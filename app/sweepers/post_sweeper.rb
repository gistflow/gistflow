class PostSweeper < ActionController::Caching::Sweeper
  observe Post
  
  def after_update post
    expire_cache_for post
  end

protected
  
  def expire_cache_for post
    expire_fragment post.cache_key(:preview)
    expire_fragment post.cache_key(:detail)
    expire_fragment post.cache_key(:feed)
  end
end
