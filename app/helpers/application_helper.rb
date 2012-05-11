module ApplicationHelper
  def all_posts_page?
    ['/', '/all'].include? request.fullpath
  end

  def followed_posts_page?
    '/following' == request.fullpath
  end
  
  def observed_posts_page?
    '/observing' == request.fullpath
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
  
  def link_to_bookmark(post)
    if bookmark = current_user.bookmark?(post)
      link_to 'Unbookmark', [:account, bookmark],
        remote: true, method: :delete, class: %w(button replaceable)
    else
      replaceable_form_for [:account, post.bookmarks.build] do |f|
        concat(f.hidden_field :post_id)
        concat(f.submit 'Bookmark', class: 'button')
      end
    end
  end
  
  def link_to_observe(post)
    if observing = current_user.observe?(post)
      link_to 'Unobserve', [:account, observing],
        remote: true, method: :delete, class: %w(button replaceable)
    else
      replaceable_form_for [:account, post.observings.build] do |f|
        concat(f.hidden_field :post_id)
        concat(f.submit 'Observe', class: 'button')
      end
    end
  end
  
  def link_to_like(post)
    if !user_signed_in? or current_user.like?(post)
      title = post.likes_count == 1 ? '1 Like' : "#{post.likes_count} Likes"
      link_to title, '#', rel: 'nofollow', class: %w(icon like button replaceable disabled)
    else
      replaceable_form_for [:account, post.likes.build] do |f|
        concat(f.hidden_field :post_id)
        concat(f.submit 'Like', class: %w(icon like button))
      end
    end
  end
  
  def replaceable_form_for record, options = {}, &proc
    options[:remote] = true
    options[:html] ||= {}
    options[:html][:class] ||= 'replaceable'
    form_for(record, options, &proc)
  end
  
  def link_to_tag(tag)
    link_to tag.with_sign, tag, :id => tag.dom_link_id
  end
  
  def link_to_comments(post)
    link_to "Comments (#{post.comments_count})", post, class: 'button icon comment'
  end
  
  # def link_to_like(post)
  #   if !user_signed_in? or current_user == post.user or post.liked_by? current_user
  #     title = post.likes_count == 1 ? '1 Like' : "#{post.likes_count} Likes"
  #     content_tag :span, title,
  #       class: 'button icon like disabled'
  #   else
  #     link_to "Like", like_post_path(post), {
  #       class: 'button icon like replaceable',
  #       method: :post,
  #       remote: true
  #     }
  #   end
  # end
  
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
end
