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
  
  task fix_settings: :environment do
    Settings.where(:default_wall => 'followed').update_all(:default_wall => 'following')
    Settings.where(:default_wall => 'observed').update_all(:default_wall => 'observing')
  end
  
  task create_profiles: :environment do
    User.all.each do |u| 
      u.create_profile do |p|
        p.company = u.company
        p.github_page = u.github_page
        p.home_page = u.home_page
        p.email = u.email
      end
    end
  end

  task setup_likes_and_bookmarks: :environment do
    [
      {"id"=>1, "memorized"=>["3", "14", "34", "58", "59", "82", "94", "103", "108"], "liked"=>["3", "14", "34", "58", "59", "82", "94", "103", "108"]}, {"id"=>2, "memorized"=>["2", "3", "5", "8", "11", "12", "13", "32", "50", "84", "97", "98", "99"], "liked"=>["2", "3", "5", "8", "11", "12", "13", "32", "50", "84", "97", "98", "99"]}, {"id"=>3, "memorized"=>["1", "17"], "liked"=>["1", "17"]}, {"id"=>9, "memorized"=>["47"], "liked"=>["47"]}, {"id"=>15, "memorized"=>["39", "47"], "liked"=>["39", "47"]}, {"id"=>20, "memorized"=>["43"], "liked"=>["43"]}, {"id"=>32, "memorized"=>["83"], "liked"=>["83"]}, {"id"=>34, "memorized"=>["95", "96", "98", "99"], "liked"=>["95", "96", "98", "99"]}, {"id"=>45, "memorized"=>["83", "87"], "liked"=>["83", "87"]}, {"id"=>46, "memorized"=>["67", "83"], "liked"=>["67", "83"]}
    ].each do |data|
      begin
        user = User.find(data['id'])
        data['memorized'].each do |post_id|
          begin
            user.bookmarks.create do |bookmark|
              bookmark.post = Post.find(post_id)
            end
          rescue
          end
        end
        data['liked'].each do |post_id|
          begin
            user.likes.create do |like|
              like.post = Post.find(post_id)
            end
          rescue
          end
        end
      rescue
      end
    end
  end
end
