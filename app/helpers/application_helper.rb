module ApplicationHelper
  def link_to_gist(gist)
    options = {
      :class => :'importable-gist',
      :'data-gist-id' => gist.id,
      :'data-gist-lang' => gist.lang
    }
    (link_to gist.id, '#', options) << ' ' << gist.description
  end
  
  def link_to_gists(user)
    un = user.username
    title, url = "#{un}'s gists", "https://gist.github.com/#{un}"
    (link_to title, url) << " on Github"
  end
  
  
  def title(title)
    content_for(:title, title)
  end
  
  def commit_title(commit = 'Commit')
    commit << ' ' << (mac? ? '&#x2318;' : '&#x2303;') << '&#x21A9;'
    commit.html_safe
  end
  
  def mac?
    request.env['HTTP_USER_AGENT'].to_s =~ /Macintosh/
  end
  
  def avatar_image(user, size = 26, type = :user)
    url = case type
    when :user then user.gravatar(size)
    when :article then asset_path('article.png')
    when :question then asset_path('question.png')
    end
    image_tag url, :size => [size, size].join('x')
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
  
  def link_to_notifiable(notification)
    notifiable = notification.notifiable
    post = notifiable.is_a?(Comment) ? notifiable.post : notifiable
        
    username = notifiable.user.username
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
  
  def javascript_enabled?
    content_tag(:noscript) do
      concat(image_tag asset_path("no_js.jpg"), :alt => 'You have not JS')
    end
  end
  
  def render_error(image_path, message)
    content_tag(:div, { :class => 'error' }) do
      [image_tag(image_path), content_tag(:h1, message)].join.html_safe
    end
  end
end
