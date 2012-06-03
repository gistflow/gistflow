module WikiHelper
  def wiki_preview(wiki)
    format wiki.preview
  end
  
  def wiki_body(wiki)
    format wiki.body
  end
  
protected
  
  def format(text)
    Markdown.markdown(begin
      raw = Replaceable.new(text)
      raw.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
end