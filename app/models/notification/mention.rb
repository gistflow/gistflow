class Notification::Mention < Notification
  include ActionView::Helpers::UrlHelper
  
  def message post_title = false
    send("message_for_#{notifiable_type.downcase}", post_title).html_safe
  end
  
protected
  
  def message_for_post post_title
    user, post = notifiable.user, notifiable
    link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
    
    title = post.title_for_notification post_title
    link_to_post = %{<a href="#{host}/posts/#{post.id}" data-title="#{post.title}" class="notification_link">post #{title}</a>}
    "#{link_to_user} mentioned you in #{link_to_post}"
  end
  
  def message_for_comment post_title
    user, comment, post = notifiable.user, notifiable, notifiable.post
    link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
    
    title = post.title_for_notification post_title
    link_to_post = %{<a href="#{host}/posts/#{post.id}#comment-#{comment.id}" data-title="#{post.title}" class="notification_link">post #{title}</a>}
    "#{link_to_user} mentioned you in comment to #{link_to_post}"
  end
end