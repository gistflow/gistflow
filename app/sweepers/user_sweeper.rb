class UserSweeper < ActionController::Caching::Sweeper
  observe User
  
  def after_create user
    expire_cache_for user
  end
  
  def after_destroy user
    expire_cache_for user
  end

protected
  
  def expire_cache_for user
    expire_fragment user.todolist_cache_key
  end
end