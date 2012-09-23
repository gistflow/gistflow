module PostHelper
  def post_preview(post)
    post_markup post.preview
  end
  
  def post_body(post)
    post_markup post.body
  end
  
  def post_timestamp(post)
    time_tag post.updated_at, post.updated_at.to_date.to_formatted_s(:long)
  end
  
  def post_title(post)
    link_to_user = link_to post.user, post.user
    "#{link_to_post(post)} <span>by #{link_to_user}</span>".html_safe
  end
  
  def link_to_post(post)
    klass = post.is_private? ? 'private' : ''
    link_to post.title, post_path(post), class: klass
  end
  
protected
  
  def post_markup(text)
    html = Markdown.markdown(text)
    replaceable = Replaceable.new(html)
    replaceable.replace(:gists, :tags, :usernames, :emoji)
    replaceable.to_s
  end
end
