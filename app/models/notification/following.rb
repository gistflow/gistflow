class Notification::Following < Notification
  include ActionView::Helpers::UrlHelper
  
  def message
    user = notifiable.follower
    link_to_follower = %{<a href="/users/#{user.username}">#{user}</a>}
    "#{link_to_follower} started following you.".html_safe
  end
end