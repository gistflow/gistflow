module MenuHelper
  def ul(array, params = {})
    return if array.empty?
    
    content_tag(:ul, params) do
      array.each do |element|
        concat(content_tag :li, element)
      end
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
      
      items << link_to('settings', account_settings_path)
      items << link_to('logout', logout_path)
    else
      items << link_to('login', auth_path, :class => 'login')
    end
    items
  end
end
