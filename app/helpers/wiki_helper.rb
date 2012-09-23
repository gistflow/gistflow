module WikiHelper
  def wiki_preview(wiki)
    wiki_markup wiki.preview
  end
  
  def wiki_body(wiki)
    wiki_markup wiki.body
  end
  
protected
  
  def wiki_markup(text)
    html = Markdown.markdown(text)
    replaceable = Replaceable.new(html)
    replaceable.replace(:tags, :usernames)
    replaceable.to_s.html_safe
  end
end