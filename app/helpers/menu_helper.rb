module MenuHelper
  def ul(array, params = {})
    content_tag(:ul, params) do
      array.each do |element|
        concat(content_tag :li, element)
      end
    end
  end
  
  def login_url
    if Rails.env.development?
      login_path
    else
      "https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_KEY']}"
    end
  end
  
  def authentication_menu
    capture_haml do
      haml_tag :ul, :class => 'authentication' do
        authentication_items.each_with_index do |item, index|
          haml_tag :li, item
        end
      end
    end
  end
    
  def authentication_items
    items = []
    if user_signed_in?
      
      items << link_to(
        current_user.username, 
        user_path(current_user.username), 
        :class => 'username'
      )
      
      unread_notifications = current_user.notifications.unread
      if unread_notifications.any?
        unread_notifications_block = "+#{unread_notifications.count}" 
      end
      
      items << link_to(
        "notifications#{unread_notifications_block}".html_safe,     
        account_notifications_path,
        :class => "#{'green' if unread_notifications.any?}"
      )
      items << link_to('logout', logout_path)
    else
      items << link_to('login', login_url, :class => 'login')
    end
    items
  end
  
  def following_form user
    form = render partial: "account/followings/form", locals: { user: user }
    form if user_signed_in? && user != current_user
  end
  
  def followers_link user
    link_to "Followers #{user.followers.count}", followers_user_path(user)
  end
  
  def followed_users_link user
    link_to "Following #{user.followed_users.count}", following_user_path(user)
  end
end
