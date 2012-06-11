class FollowingSweeper < ActionController::Caching::Sweeper
  observe Following
  
  def after_create following
    expire_fragment "todolist:#{following.follower_id}"
  end
end