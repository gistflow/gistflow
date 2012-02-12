module MenuHelper
  def login_url
    if Rails.env.development?
      login_path
    else
      'https://github.com/login/oauth/authorize?client_id=83dfd929d47091e3902d'
    end
  end
  
  def categories_menu
    capture_haml do
      categories_items.each do |item|
        haml_tag :small do
          haml_concat item
        end
      end
    end
  end
  
  def authentication_menu
    capture_haml do
      haml_tag :ul, :class => 'authentication' do
        authentication_items.each_with_index do |item, index|
          haml_tag :li do
            haml_concat item
            if authentication_items.size != index.next
              haml_tag(:span) { haml_concat '|' }
            end
          end
        end
      end
    end
  end
  
protected
  
  def categories_items
    { :articles  => articles_path,
      :questions => questions_path,
      :community => community_index_path }.map do |name, link|
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
