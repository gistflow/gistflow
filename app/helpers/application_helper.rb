# coding: utf-8
module ApplicationHelper
  def self.define_partial_helpers(*partials)
    partials.each do |partial|
      define_method partial do |content|
        content_for partial, content
      end
    end
  end
  
  define_partial_helpers :title, :description, :keywords, :window_title
  
  def render_git_version
    "<!-- version: #{Gistflow::VERSION} -->".html_safe
  end
  
  def auth_path
    '/auth/github'
  end
  
  def link_to_gists(user)
    un = user.username
    title, url = "#{un}'s gists", "https://gist.github.com/#{un}"
    (link_to title, url) << " on Github"
  end
  
  def commit_title(commit = 'Commit')
    commit << ' ' << (mac? ? '&#x2318;' : '&#x2303;') << '&#x21A9;'
    commit.html_safe
  end
  
  def mac?
    request.env['HTTP_USER_AGENT'].to_s =~ /Macintosh/
  end
  
  def avatar_image(user, size = 52, type = :user)
    image_tag user.gravatar(size), size: [size, size].join('x')
  end
  
  def link_to_bookmark(post)
    classes = %w(button bookmark replaceable icon-bookmark-empty)
    link_to '', account_bookmark_path(post),
      { class: classes, remote: true, method: :post, title: 'Bookmark' }
  end
  
  def link_to_unbookmark(post)
    classes = %w(button bookmark replaceable icon-bookmark)
    link_to '', account_bookmark_path(post),
      { class: classes, remote: true, method: :delete, title: 'Unbookmark' }
  end
  
  def link_to_observe(post)
    classes = %w(button observe replaceable icon-eye-close)
    link_to "", account_observe_path(post),
      { class: classes, remote: true, method: :post, title: 'Observe' }
  end
  
  def link_to_unobserve(post)
    classes = %w(button observe replaceable icon-eye-open)
    link_to "", account_observe_path(post),
      { class: classes, remote: true, method: :delete, title: 'Unobserve' }
  end
  
  def link_to_like(post)
    classes = %w(like button replaceable)
    link_to %{<span>#{post.likes_count}</span> <i class="icon-heart-empty"></i>}.html_safe, account_likes_path(:post_id => post.id), class: classes, remote: true, method: :post, title: 'Like post :)'
  end
  
  def link_to_unlike(post)
    classes = %w(like button replaceable)
    link_to %{<span>#{post.likes_count}</span> <i class="icon-heart"></i>}.html_safe, account_likes_path(:post_id => post.id), method: :delete, remote: true, class: classes, title: 'Unlike post'
  end
  
  def link_to_subscribe(tag, options = {})
    default_options = {
      method:    :post,
      class:     %w(button subscribe replaceable),
      :remote    => true,
      :'data-id' => tag.id
    }
    options = default_options.merge(options)
    if options[:onoff]
      name = options[:method] == :post ? 'Subscribe' : 'Subscribed'
    else
      name = tag.name
    end
    link_to name, account_subscribe_path(tag, :onoff => options[:onoff]),
      options
  end
  
  def link_to_unsubscribe(tag, options = {})
    default_options = {
      class: 'button subscribe replaceable active',
      method: :delete
    }
    link_to_subscribe(tag, default_options.merge(options))
  end
  
  def link_to_follow(user, name = 'Follow', method = :post)
    link_to name, account_follow_path(user),
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
    link_to '', post, class: 'button comment', title: 'Comments'
  end
  
  def link_to_github_user(user)
    link = "http://github.com/#{user.username}"
    link_to link, link, target: "_blank"
  end
  
  def link_to_new_post
    content_tag(:span, '→', class: 'arrow') << 
      link_to('New Post', new_post_path, :class => 'button primary')
  end
  
  def subscription_form(subscription)
    locals = { subscription: subscription }
    partial = subscription.new_record? ? 'form' : 'destroy_form'
    render partial: "subscriptions/#{partial}", locals: locals
  end
  
  def javascript_enabled?
    content_tag(:noscript, id: 'nojs') do
      concat(image_tag asset_path('no_js.jpg'), alt: 'You have not JS')
    end
  end
  
  def link_to_url url, options = {}
    if !url.blank? && url =~ URI::regexp(%w(http https))
      link_to url, url, options
    end
  end

  def load_time_counters
    points = TimeCounter.for_landing.group_by(&:date).each_pair.map do |date, data|
      grouped_data = data.group_by(&:model)
      [date.strftime("%b, %d"), TimeCounter::MODELS.map { |m| grouped_data[m.to_s] ? grouped_data[m.to_s].first.total_count : nil }].flatten
    end

    points.insert(0, TimeCounter::MODELS.dup.insert(0, 'Date'))
    points.to_json.html_safe
  end
  
  def link_to_tweet(post)
    data = {
      url: post_url(post),
      text: post.title
    }
    link_to " <span>Tweet</span>".html_safe, "https://twitter.com/share?#{data.to_param}", class: 'button icon-twitter', target: '_blank'
  end
  
  def gists_page?
    [:show, :new, :create, :edit, :update].any? do |action|
      params[:controller].to_sym == :posts && action == params[:action].to_sym
    end
  end

  def posts_hash(posts)
    hash = {}
    posts.each do |post|
      hash[post.id] = post.as_json(only: [:id, :likes_count, :comments_count])
    end
    hash
  end
end