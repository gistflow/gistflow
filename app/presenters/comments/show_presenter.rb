class Comments::ShowPresenter
  attr_reader :controller, :comment
  
  extend ActiveModel::Naming
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  
  def initialize(comment)
    comment.replace_gists!
    comment.replace_tags!
    comment.replace_usernames!
    @comment = comment
  end
  
  def title
    u = link_to user.username, user_path(:id => user.username), :class => 'username'
    w = time_ago_in_words(comment.created_at)
    "#{u} commented #{w} ago".html_safe
  end
  
  def user
    comment.user
  end
  
  def content
    comment.content
  end
end
