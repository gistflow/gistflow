module MenuHelper
  def ul(array)
    content_tag(:ul) do
      array.each do |element|
        concat(content_tag :li, element)
      end
    end
  end
  
  def login_url
    if Rails.env.development?
      login_path
    else
      'https://github.com/login/oauth/authorize?client_id=83dfd929d47091e3902d'
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
  
  def post_items
    if user_signed_in?
      [link_to('New Post', new_post_path)]
    else
      []
    end
  end
  
  def categories_items
    { :Articles  => post_articles_path,
      :Questions => post_questions_path,
      :Gossips => post_gossips_path }.map do |name, link|
      link_to_unless_current name, link
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
      unread_notifications_block = content_tag(
        :span, "+#{unread_notifications.count}", 
        :class => "unread_notification_counter"
      ) if unread_notifications.any?
      
      items << link_to(
        "notifications#{unread_notifications_block}".html_safe,     
        notifications_path
      )
      items << link_to('logout', logout_path)
    else
      items << link_to('login', login_url, :class => 'login')
    end
    items
  end
  
end
