module Markdown
  ALLOWED_ELEMENTS = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'code', 'pre', 'ul',
    'ol', 'dl', 'dt', 'dd', 'blockquote', 'img', 'strong', 'em', 'span', 'div',
    'a', 'li']

  def self.markdown(text)
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
    Sanitize.clean(doc.to_s, {
      elements: ALLOWED_ELEMENTS,
      attributes: { all: ['href', 'src', 'alt', 'title', 'class'] }
    })
  end
end