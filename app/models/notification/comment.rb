class Notification::Comment < Notification
  include ActionView::Helpers::UrlHelper

  def title
    "#{notifiable.user} commented on post #{notifiable.post.title}"
  end

  def mailer_title
    "New comment on post #{notifiable.post.title}"
  end

  def target_url
    "#{host}/posts/#{notifiable.post.id}"
  end

  def message post_title = false
    user, post, comment = notifiable.user, notifiable.post, notifiable
    link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}

    title = post.title_for_notification post_title
    link_to_post = %{<a href="#{host}/posts/#{post.id}#comment-#{comment.id}" data-title="#{post.title}" class="notification_link">#{title}</a>}
    "#{link_to_user} wrote a comment in #{link_to_post}".html_safe
  rescue
    "Comment was deleted"
  end

  def preview
    notifiable.body
  end
end