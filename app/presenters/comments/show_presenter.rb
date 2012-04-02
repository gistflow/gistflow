class Comments::ShowPresenter
  attr_reader :comment, :controller
  
  extend ActiveModel::Naming
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  
  def initialize(comment)
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
    @content ||= (Markdown.markdown begin
      raw = Replaceable.new(comment.content)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.body.html_safe
    end)
  end
end
