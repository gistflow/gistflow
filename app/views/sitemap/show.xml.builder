xml.instruct!
xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.to_date
      xml.priority 0.8
    end
  end
end