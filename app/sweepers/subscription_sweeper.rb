class SubscriptionSweeper < ActionController::Caching::Sweeper
  observe Subscription
  
  def after_create subscription
    expire_cache_for subscription
  end
  
  def after_destroy subscription
    expire_cache_for subscription
  end

protected
  
  def expire_cache_for subscription
    expire_fragment "sidebar:subscriptions:#{subscription.user_id}"
  end
end
