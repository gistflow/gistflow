class Notification::Mention < Notification
  include ActionView::Helpers::UrlHelper
  
  def title
    "#{notifiable.user} mentioned you in #{post.title}"
  end

  def mailer_title
    title
  end
  
  def message post_title = false
    send("message_for_#{notifiable_type.downcase}", post_title).html_safe
  end
  
  def post
    notifiable.is_a?(Post) ? notifiable : notifiable.post
  end
  
  def target_url
    "#{host}/posts/#{post.id}"
  end
  
protected
  
  def message_for_post post_title
    user, post = notifiable.user, notifiable
    link_to_user = %{<a href="#{host}/users/#{user}">#{user}</a>}
    
    title = post.title_for_notification post_title
    link_to_post = %{<a href="#{host}/posts/#{post.id}" data-title="#{post.title}" class="notification_link">#{title}</a>}
    "#{link_to_user} mentioned you in #{link_to_post}"
  rescue
    "Post was deleted"
  end
  
  def message_for_comment post_title
    user, comment, post = notifiable.user, notifiable, notifiable.post
    link_to_user = %{<a href="#{host}/users/#{user}">#{user}</a>}
    
    title = post.title_for_notification post_title
    link_to_post = %{<a href="#{host}/posts/#{post.id}#comment-#{comment.id}" data-title="#{post.title}" class="notification_link">#{title}</a>}
    "#{link_to_user} mentioned you in comment to #{link_to_post}"
  rescue
    "Comment was deleted"
  end
end