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
  
  def preview
    post.formatted_preview
  end
  
  def body
    @body ||= (Markdown.markdown begin
      raw = Replaceable.new(post.body)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
  
  def timestamp
    time_tag post.updated_at, post.updated_at.to_date.to_formatted_s(:long)
  end
  
  def title
    "#{link_to(post.title, post)} <span>by #{link_to user, user}</span>".html_safe
  end
  
  def comments
    post.comments.includes(:user).to_a.select(&:persisted?)
  end
  
  def usernames
    [*comments.map{ |c| c.user.username }, post.user.username].uniq.sort
  end
end