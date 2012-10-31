namespace :posts do
  task update_page_views: :environment do
    google_analytics = GA.new

    Post.limit(ENV['LIMIT'] || 50).each do |post|
      page_views = google_analytics.page_views post
      post.update_attribute(:page_views, page_views) if page_views
      Rails.cache.delete post.cache_key(:detail)
    end
  end
end