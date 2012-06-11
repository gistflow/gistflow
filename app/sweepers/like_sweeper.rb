class LikeSweeper < ActionController::Caching::Sweeper
  observe Like
  
  def after_create like
    expire_fragment "todolist:#{like.user_id}"
  end
end