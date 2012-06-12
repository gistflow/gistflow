module WikiHelper
  def wiki_preview(wiki)
    markup wiki.preview
  end
  
  def wiki_body(wiki)
    markup wiki.body
  end
  
protected
  
  def markup(text)
    Markdown.markdown(begin
      raw = Replaceable.new(text)
      raw.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
end