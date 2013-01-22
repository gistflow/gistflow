xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Gistflow :: All"
    xml.description "Social learning"
    xml.link posts_url

    @posts.each do |post|
      cache post.cache_key(:feed) do
        xml.item do
          xml.title post.title
          xml.description post_preview(post)
          xml.pubDate post.created_at.to_s(:rfc822)
          xml.link post_url(post)
          xml.guid post_url(post)
          post.tags.each do |tag|
            xml.category tag.name
          end
        end
      end
    end
  end
end
