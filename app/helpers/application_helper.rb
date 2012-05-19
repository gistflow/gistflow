module ApplicationHelper
  def auth_path
    '/auth/github'
  end
  
  def all_posts_page?
    ['/', '/all'].include? request.fullpath
  end
  
  def link_to_gists(user)
    un = user.username
    title, url = "#{un}'s gists", "https://gist.github.com/#{un}"
    (link_to title, url) << " on Github"
  end
  
  def title(title)
    content_for(:title, title)
  end
  
  def window_title(title)
    content_for(:window_title, title)
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
  
  def link_to_bookmark(post, name = 'Bookmark', method = :post)
    classes = %w(button bookmark replaceable)
    link_to name, account_bookmark_path(post),
      { class: classes, remote: true, method: method }
  end
  
  def link_to_unbookmark(post)
    link_to_bookmark(post, 'Unbookmark', :delete)
  end
  
  def link_to_observe(post, name = 'Observe', method = :post)
    classes = %w(button observe replaceable)
    link_to name, account_observe_path(post),
      { class: classes, remote: true, method: method }
  end
  
  def link_to_unobserve(post)
    link_to_observe(post, 'Unobserve', :delete)
  end
  
  def link_to_like(post)
    classes = %w(icon like button replaceable disabled)
    link_to 'Like', account_like_path(post), class: classes, remote: true, method: :post
  end
  
  def link_to_liked(post)
    name = (post.likes_count == 1) ? '1 Like' : "#{post.likes_count} Likes"
    link_to name, '#', class: 'icon like button replaceable disabled'
  end
  
  def link_to_subscribe(tag, method = :post, options = {})
    link_to tag.name, account_subscribe_path(tag),
      { :remote    => true,
        :method    => method,
        :class     => 'button subscribe replaceable',
        :'data-id' => tag.id }.merge(options)
  end
  
  def link_to_unsubscribe(tag)
    options = { class: 'button subscribe replaceable active' }
    link_to_subscribe(tag, :delete, options)
  end
  
  def link_to_follow(user, name = 'Follow', method = :post)
    link_to name, account_following_path(user),
      { :remote    => true,
        :method    => method,
        :class     => 'button follow replaceable',
        :'data-id' => user.id }
  end
  
  def link_to_unfollow(user)
    link_to_follow user, 'Unfollow', :delete
  end
  
  def link_to_tag(tag)
    link_to tag.with_sign, tag
  end
  
  def link_to_comments(post)
    link_to "Comments", post, class: 'button icon comment'
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
  
  def javascript_enabled?
    content_tag(:noscript) do
      concat(image_tag asset_path('no_js.jpg'), alt: 'You have not JS')
    end
  end
  
  def link_to_url url, options = {}
    if !url.blank? && url =~ URI::regexp(%w(http https))
      link_to url, url, options
    end
  end
end
