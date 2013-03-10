module Markdown
  ALLOWED_ELEMENTS = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'code', 'pre', 'ul',
    'ol', 'dl', 'dt', 'dd', 'blockquote', 'img', 'strong', 'em', 'span', 'div',
    'a', 'li']

  def self.markdown(text, options = {})
    html = ::GitHub::Markdown.render_gfm(text)
    
    doc = Nokogiri::HTML(html)
    doc.search("//pre").each do |pre|
      replacement = 
        begin
          Pygments.highlight(pre.text.rstrip, lexer: pre[:lang])
        rescue MentosError
        end
      pre.replace replacement if replacement
    end
    html = Sanitize.clean(doc.to_s, {
      elements: ALLOWED_ELEMENTS,
      attributes: { all: ['href', 'src', 'alt', 'title', 'class'] }
    })
    
    if options[:flavored]
      replaceable = Replaceable.new(html)
      replaceable.replace(:gists, :tags, :usernames, :emoji)
      html = replaceable.to_s.html_safe
    end
    
    html
  end
end