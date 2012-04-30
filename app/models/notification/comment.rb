class Notification::Comment < Notification
  include ActionView::Helpers::UrlHelper
  
  def message
    user, post, comment = notifiable.user, notifiable.post, notifiable
    link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
    link_to_post = %{<a href="/posts/#{post.id}#comment-#{comment.id}">post #{post.id}</a>}
    "#{link_to_user} wrote a comment in #{link_to_post}".html_safe
  end
end
