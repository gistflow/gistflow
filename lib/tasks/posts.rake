namespace :posts do
  task update_page_views: :environment do
    google_analytics = GA.new

    Post.all.each do |post|
      page_views = google_analytics.page_views post
      post.update_attribute(:page_views, page_views) if page_views
    end

    Rails.cache.clear
  end
end