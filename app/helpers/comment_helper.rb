module CommentHelper
  def comment_title(comment)
    user = comment.user
    link_to_user = link_to user, user, class: 'username'
    # Time.now if it is a preview and record isn't saved yet
    commented_at = time_ago_in_words(comment.created_at || Time.now) 
    "#{link_to_user} commented #{commented_at} ago".html_safe
  end
  
  def comment_content(comment)
    html = Markdown.markdown(comment.content)
    replaceable = Replaceable.new(html)
    replaceable.replace(:gists, :tags, :usernames, :emoji)
    replaceable.to_s.html_safe
  end
end