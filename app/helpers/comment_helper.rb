module CommentHelper
  def comment_title(comment)
    user = comment.user
    link_to_user = link_to user, user, class: 'username'
    # Time.now if it is a preview and record isn't saved yet
    commented_at = time_ago_in_words(comment.created_at || Time.now) 
    "#{link_to_user} commented #{commented_at} ago".html_safe
  end
  
  def comment_content(comment)
    (Markdown.markdown begin
      raw = Replaceable.new(comment.content.dup)      
      raw.replace_gists!.
          replace_tags!.
          replace_usernames!.
          replace_emoji!
      raw.body
    end)
  end
end