class ObservingSweeper < ActionController::Caching::Sweeper
  observe Observing
  
  def after_create observing
    expire_fragment "todolist:#{observing.user_id}"
  end
end