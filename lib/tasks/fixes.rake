namespace :fixes do
  task setup_cache_for_current_posts: :environment do
    Post.all.each(&:save)
  end
  
  task clean_old_notifications: :environment do
    Notification.where(type: nil).delete_all
  end
  
  task create_settings: :environment do
    User.all.each { |u| u.create_settings }
  end
end