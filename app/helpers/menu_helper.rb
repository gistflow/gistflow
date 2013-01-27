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
      items << link_to(current_user.username, current_user, class: 'username')
      items << link_to(
        "<i class='icon-lightbulb'></i>".html_safe,     
        account_notifications_path,
        :class => "#{'glow' if current_user.notifications.unread.any?}"
      )
      items << link_to('<i class="icon-cog"></i>'.html_safe, account_settings_path)
      items << link_to('<i class="icon-signout"></i>'.html_safe, logout_path)
    else
      items << link_to('login', auth_path, :class => 'login')
    end
    items
  end
end
