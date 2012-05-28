class Notification::Following < Notification
  include ActionView::Helpers::UrlHelper
  
  def title
    "#{notifiable.follower} started following you"
  end
  
  def message *args
    user = notifiable.follower
    link_to_follower = %{<a href="#{host}/users/#{user}">#{user}</a>}
    "#{link_to_follower} started following you.".html_safe
  end
end