class PostSweeper < ActionController::Caching::Sweeper
  observe Post
  
  def after_update(post)
    clear_cache post
  end
  
  def after_destroy(post)
    clear_cache post
  end
  
protected

  def clear_cache(post)
    presenter = Posts::ShowPresenter.new(post)
    expire_fragment presenter.cache_key
  end
  
end
