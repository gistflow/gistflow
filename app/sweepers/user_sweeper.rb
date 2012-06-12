class UserSweeper < ActionController::Caching::Sweeper
  observe User
  
  def after_touch(user)
    expire_fragment_for user
  end
  
protected
  
  def expire_fragment_for(user)
    expire_fragment user.todolist_cache_key
  end
end