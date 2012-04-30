class Notification::Comment < Notification
  include ActionView::Helpers::UrlHelper
  
  delegate :post, to: :notifiable
  
  def message
    link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
    link_to_post = %{<a href="/posts/#{post.id}">#{post.link_name}</a>}
    "#{link_to_user} wrote a comment in #{link_to_post}"
  end
end
