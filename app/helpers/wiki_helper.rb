module WikiHelper
  def wiki_preview(wiki)
    wiki_markup wiki.preview
  end
  
  def wiki_body(wiki)
    wiki_markup wiki.body
  end
  
protected
  
  def wiki_markup(text)
    Markdown.markdown(begin
      raw = Replaceable.new(text)
      raw.replace_tags!.replace_usernames!
      raw.to_s
    end)
  end
end