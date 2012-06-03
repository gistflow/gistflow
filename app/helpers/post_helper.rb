module PostHelper
  def post_preview(post)
    format post.preview
  end
  
  def post_body(post)
    format post.body
  end
  
  def post_timestamp(post)
    time_tag post.updated_at, post.updated_at.to_date.to_formatted_s(:long)
  end
  
  def post_title(post)
    link_to_user = link_to post.user, post.user
    "#{link_to(post.title, post)} <span>by #{link_to_user}</span>".html_safe
  end
  
protected
  
  def format(text)
    (Markdown.markdown begin
      raw = Replaceable.new(text)
      raw.replace_gists!.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
end