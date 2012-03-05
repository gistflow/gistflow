class Posts::ShowPresenter
  attr_reader :controller, :post
  
  extend ActiveModel::Naming
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  
  def initialize(post)
    @post = post
  end
  
  def cache_key
    "post:#{post.id}"
  end
  
  def preview
    @preview ||= begin
      content = (parsed_preview || parsed_title)
      raw = Replaceable.new(content)
      raw.replace_tags!
      raw.replace_usernames!
      raw.content.html_safe
    end
  end
  
  def body
    @body ||= (Markdown.markdown begin
      content = (parsed_body || parsed_preview || parsed_title)
      raw = Replaceable.new(content)
      raw.replace_tags!
      raw.replace_gists!
      raw.replace_usernames!
      raw.content.html_safe
    end)
  end
  
  def title
    u = link_to user.username, user_path(:id => user.username), :class => 'username'
    t = link_to type, type_path
    w = time_ago_in_words(post.created_at)
    "#{u} wrote in #{t} #{w} ago".html_safe
  end
  
  def user
    post.user
  end
  
  def type
    post.type.split('::').last.downcase
  end
  
  def likes_count
    post.likes_count
  end
  
  def comments_count
    post.comments_count
  end
  
  def comments
    post.comments.to_a.select(&:persisted?)
  end
  
protected

  def type_path
    case post.class.to_s
    when 'Post::Article' then
      post_articles_path
    when 'Post::Question' then
      post_questions_path
    when 'Post::Gossip' then
      post_gossips_path
    end
  end

  def content
    post.content
  end
  
  def parsed_title
    @parsed_title ||= content_parts[0]
  end
  
  def parsed_preview
    @parsed_preview ||= content_parts[1]
  end
  
  def parsed_body
    @parsed_body ||= content_parts[2]
  end
  
  def content_parts
    @content_parts ||= content.to_s.gsub("\r", '').split("\n\n", 3)
  end
end