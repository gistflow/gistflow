class Posts::ShowPresenter
  attr_reader :controller, :post
  
  extend ActiveModel::Naming
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  
  delegate :user, :likes_count, :comments_count, :to => :post
  
  def initialize(post)
    @post = post
  end
  
  def cache_key
    "post:#{post.id}"
  end
  
  def preview
    @preview ||= (Markdown.markdown begin
      raw = Replaceable.new(post.preview, :preview => true)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.body.html_safe
    end)
  end
  
  def body
    @body ||= (Markdown.markdown begin
      raw = Replaceable.new(post.body)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.body
    end)
  end
  
  def title
    if post.title?
      c = link_to post.category, post_path(post), :class => 'label'
      t = link_to post.title, post
      "#{t} #{c}".html_safe
    else
      simple_title
    end
  end
  
  def simple_title
    u = link_to user.username, user_path(:id => user.username), :class => 'username'
    t = link_to "post", post
    w = time_ago_in_words(post.created_at)
    "#{u} wrote in #{t} #{w} ago".html_safe
  end
  
  def detail_title
    if post.title?
      link_to post.title, post
    else
      simple_title
    end
  end
  
  def comments
    post.comments.to_a.select(&:persisted?)
  end
end