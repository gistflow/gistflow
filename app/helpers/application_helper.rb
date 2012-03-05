module ApplicationHelper
  def caption(caption)
    capture_haml do
      haml_tag(:div, { :class => :caption }) do
        haml_concat caption
      end
    end
  end
  
  def avatar_image(user, size = 26)
    image_tag user.gravatar(size), :size => '26x26'
  end
  
  def credits
    creators = ['releu', 'makaroni4'].shuffle.map do |u|
      link_to "@#{u}", "https://github.com/#{u}"
    end
    
    "Created by #{creators[0]} and #{creators[1]}".html_safe
  end
  
  def link_to_memorize(post)
    if current_user.memorized? post
      link_to 'Forgot', forgot_post_path(post), 
        :method => :delete, :remote => true, :class => 'button replaceable'
    else
      link_to 'Memorize', memorize_post_path(post),
        :method => :post, :remote => true, :class => 'button replaceable'
    end
  end
  
  def link_to_like(post)
    if current_user == post.user or post.liked_by? current_user
      link_to "#{post.likes_count} Likes", '#',
        :class => 'button icon like disabled'
    else
      link_to "Like", like_post_path(post),
        :class => 'button icon like replaceable', :method => :post, :remote => true
    end
  end
    
  def caption_haml(title)
    haml_tag :div, :class => 'caption' do
      haml_concat title
    end
  end
  
  def user_page_title(user)
    name = current_user == user ? "Your" : "#{user.username}'s"
    capture_haml do
      caption_haml "#{name} posts"
    end
  end
    
  def link_to_notifiable(notification)
    username = notification.notifiable.user.username
    user_link = link_to(
      username, 
      user_path(:id => username), 
      :class => 'username'
    )
    record_link = notification.notifiable.link_to_post
    
    time = time_ago_in_words(notification.created_at)
    
    "#{user_link} mentioned you in #{record_link} #{time} ago".html_safe
  end
  
  def link_to_github_user(user)
    link = "http://github.com/#{user.username}"
    link_to link, link, :target => "_blank"
  end
  
  def subscription_form(subscription)
    locals = { :subscription => subscription }
    partial = subscription.new_record? ? 'form' : 'destroy_form'
    render :partial => "subscriptions/#{partial}", :locals => locals
  end
  
  def current_type
    params[:controller].split('/').last.singularize
  end
end
