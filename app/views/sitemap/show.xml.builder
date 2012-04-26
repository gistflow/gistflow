xml.instruct!
xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  @users.each do |user|
    xml.url do
      xml.loc user_url(user)
    end
  end
  @tags.each do |tag|
    xml.url do
      xml.loc tag_url(tag)
    end
  end
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.to_date
    end
  end
end