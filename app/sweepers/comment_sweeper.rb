class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment
  
  def after_create comment
    expire_cache_for comment
    expire_fragment "todolist:#{comment.user_id}"
  end
  
  def after_destroy comment
    expire_cache_for comment
  end

protected
  
  def expire_cache_for comment
    expire_fragment "sidebar:comments:#{comment.user_id}"
  end
end