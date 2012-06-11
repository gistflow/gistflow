class BookmarkSweeper < ActionController::Caching::Sweeper
  observe Bookmark
  
  def after_create bookmark
    expire_cache_for bookmark
    expire_fragment "todolist:#{bookmark.user_id}"
  end
  
  def after_destroy bookmark
    expire_cache_for bookmark
  end

protected
  
  def expire_cache_for bookmark
    expire_fragment "sidebar:bookmarks:#{bookmark.user_id}"
  end
end