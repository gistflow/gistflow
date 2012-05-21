class Notification::Following < Notification
  include ActionView::Helpers::UrlHelper
  
  def message *args
    user = notifiable.follower
    link_to_follower = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
    "#{link_to_follower} started following you.".html_safe
  end
end