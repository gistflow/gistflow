class Posts::ShowPresenter
  attr_reader :post, :controller
  
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
      raw = Replaceable.new(post.preview)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
  
  def body
    @body ||= (Markdown.markdown begin
      raw = Replaceable.new(post.body)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
  
  def title
    "#{link_to(post.title, post)} <span>by #{link_to user, user}</span>".html_safe
  end
  
  def comments
    post.comments.to_a.select(&:persisted?)
  end
end