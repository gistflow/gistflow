module ApplicationHelper
  def link_to_gist(gist)
    options = {
      :class            => :'importable-gist',
      :'data-gist-id'   => gist.id,
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
    image_tag user.gravatar(size), size: [size, size].join('x')
  end
  
  def link_to_memorize(post)
    base_url, base_options = { controller: post.controller, id: post.id },
      { remote: true, class: 'button replaceable remembrance' }
    
    title, url, options = if current_user.memorized? post
      ['Forgot', { action: :forgot }, { method: :delete }]
    else
      ['Memorize', { action: :memorize }, { method: :post }]
    end
    
    link_to title, base_url.merge!(url), base_options.merge!(options)
  end
  
  def link_to_comments(post)
    link_to "Comments (#{post.comments_count})", {
      controller: post.controller,
      action:     :show,
      id:         post.id,
      anchor:     'comments'
    }, class: 'button icon comment'
  end
  
  def link_to_like(post)
    if !user_signed_in? or current_user == post.user or post.liked_by? current_user
      content_tag :span, "#{post.likes_count} Likes",
        class: 'button icon like disabled'
    else
      link_to "Like", { 
        controller: post.controller, 
        action:     :like, 
        id:         post.id 
      }, {
        class: 'button icon like replaceable',
        method: :post,
        remote: true
      }
    end
  end
  
  def link_to_notifiable(notification)
    notifiable = notification.notifiable
    post = notifiable.is_a?(Comment) ? notifiable.post : notifiable
        
    username = notifiable.user.username
    user_link = link_to(username, user_path(:id => username),
      class: 'username')
    
    # IDEA may be we need #tags in page so link to notifiable lead to
    # exact comment or post
    record_link = link_to post.title || 'gossip', {
      controller: post.controller,
      action:     :show,
      id:         post.id
    }
    
    time = time_ago_in_words(notification.created_at)
    
    "#{user_link} mentioned you in #{record_link} #{time} ago".html_safe
  end
  
  def link_to_github_user(user)
    link = "http://github.com/#{user.username}"
    link_to link, link, target: "_blank"
  end
  
  def subscription_form(subscription)
    locals = { subscription: subscription }
    partial = subscription.new_record? ? 'form' : 'destroy_form'
    render partial: "subscriptions/#{partial}", locals: locals
  end
  
  def current_type
    params[:controller].split('/').last.singularize
  end
  
  def javascript_enabled?
    content_tag(:noscript) do
      concat(image_tag asset_path('no_js.jpg'), alt: 'You have not JS')
    end
  end
end
