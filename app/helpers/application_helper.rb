module ApplicationHelper
  def caption(caption, options = {})
    classes = [:caption]
    classes << 'highlight' if options[:highlight]
    
    capture_haml do
      haml_tag(:div, { :class => classes.join(' ') }) do
        haml_concat caption
      end
    end
  end
  
  def avatar_image(user, size = 26)
    image_tag user.gravatar(size), :size => [size, size].join('x')
  end
  
  def credits
    creators = ['releu', 'makaroni4'].shuffle.map do |u|
      link_to "@#{u}", "https://github.com/#{u}"
    end
    
    "Created by #{creators[0]} and #{creators[1]}".html_safe
  end
  
  def link_to_memorize(post)
    if current_user.memorized? post
      link_to 'Forgot', { 
          :controller => post.controller, 
          :action => :forgot, 
          :id => post.id 
        }, 
        :method => :delete, :remote => true, :class => 'button replaceable remembrance'
    else
      link_to 'Memorize', { 
          :controller => post.controller, 
          :action => :memorize, 
          :id => post.id 
        }, :method => :post, :remote => true, :class => 'button replaceable remembrance'
    end
  end
  
  def link_to_like(post)
    if current_user == post.user or post.liked_by? current_user
      link_to "#{post.likes_count} Likes", '#',
        :class => 'button icon like disabled'
    else
      link_to "Like", { 
        :controller => post.controller, 
        :action => :like, 
        :id => post.id 
        }, 
        :class => 'button icon like replaceable', 
        :method => :post, 
        :remote => true
    end
  end
    
  def caption_haml(title)
    haml_tag :div, :class => 'caption' do
      haml_concat title
    end
  end
  
  def link_to_notifiable(notification)
    post = notification.notifiable.post
        
    username = post.user.username
    user_link = link_to(
      username, 
      user_path(:id => username), 
      :class => 'username'
    )
    
    # IDEA may be we need #tags in page so link to notifiable lead to
    # exact comment or post
    record_link = link_to post.title || 'gossip', {
      controller: post.controller,
      action: :show,
      id: post.id
    }
    
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
