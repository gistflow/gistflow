class Posts::ShowPresenter
  attr_reader :controller, :post
  
  extend ActiveModel::Naming
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  
  def initialize(post)
    @post = post
  end
  
  def preview
    parsed_preview || parsed_title
  end
  
  def body
    Markdown.markdown begin
      parsed_body || parsed_preview || parsed_title
    end
  end
  
  def title
    if parsed_preview
      link_to parsed_title, post_path(post)
    else
      u = link_to user.username, user_path(:id => user.username), :class => 'username'
      t = link_to type, type_path
      w = time_ago_in_words(post.created_at)
      "#{u} wrote in #{t} #{w} ago".html_safe
    end
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
  
  def comments
    post.comments.select(&:persisted?)
  end
  
protected

  def type_path
    case post.class.to_s
    when 'Post::Article' then
      articles_path
    when 'Post::Question' then
      questions_path
    when 'Post::Community' then
      community_index_path
    end
  end

  def content
    post.content
  end
  
  def parsed_title
    @parsed_title ||= parse_content_parts[0]
  end
  
  def parsed_preview
    @parsed_preview ||= parse_content_parts[1]
  end
  
  def parsed_body
    @parsed_body ||= parse_content_parts[2]
  end
  
  def parse_content_parts
    content.gsub("\r", '').split("\n\n", 3)
  end
end