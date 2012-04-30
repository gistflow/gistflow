class Notification::Mention < Notification
  include ActionView::Helpers::UrlHelper
  
  def message
    send "message_for_#{notifiable_type.downcase}"
  end
  
protected
  
  def message_for_post
    post = notifiable
    link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
    link_to_post = %{<a href="/posts/#{post.id}">#{post.link_name}</a>}
    "#{link_to_user} mentioned you in #{link_to_post}"
  end
  
  def message_for_comment
    comment, post = notifiable, notifiable.post
    link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
    link_to_post = %{<a href="/posts/#{post.id}#comment-#{comment.id}">#{post.link_name}</a>}
    "#{link_to_user} mentioned you in comment to #{link_to_post}"
  end
end