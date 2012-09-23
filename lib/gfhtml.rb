class GFHTML < Redcarpet::Render::HTML
  def header(text, level)
    "<h#{level}>#{replace_all(text)}</h#{level}>"
  end
  
  def block_quote(text)
    "<blockquote>#{replace_all(text)}</blockquote>"
  end
  
  def list_item(text)
    "<li>#{text}</li>"
  end
  
  def paragraph(text)
    "<p>#{replace_all(text)}</p>"
  end
  
private
  
  def replace_all(text)
    text = Replaceable.new(text)
    text.replace_gists!.replace_tags!.replace_usernames!.replace_emoji!
    text.to_s
  end
end