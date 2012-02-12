module ApplicationHelper
  def title(title)
    content_for(:title, title)
  end
  
  def avatar_image(user, size = 26)
    image_tag user.gravatar(size)
  end
  
  def credits
    creators = ['releu', 'makaroni4'].shuffle.map do |u|
      link_to "@#{u}", "https://github.com/#{u}"
    end
    
    "Created by #{creators[0]} and #{creators[1]}".html_safe
  end
  
  def user_gists_title(user)
    title = user == current_user ? "Your gists" : "#{user.username} on Github"
    
    capture_haml do
      caption_haml title
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
  
  def sidebar_posts(title, posts, more_url)
    capture_haml do
      caption_haml title

      posts.each do |post|
        haml_tag :div, :class => 'sidebar_link' do
          #FIX post.title from content
          #FIX post_path to models_path
          haml_concat link_to(post.content[0..30], post_path(post)).html_safe
        end
      end
      haml_tag :div, :class => 'sidebar_link' do
        haml_concat link_to "more", more_url
      end
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
  
  def subscription_form(subscription)
    locals = { :subscription => subscription }
    partial = subscription.new_record? ? 'form' : 'destroy_form'
    render :partial => "subscriptions/#{partial}", :locals => locals
  end
end
