module Markdown
  def self.markdown(text)
    text = Sanitize.clean(text)
    html = ::GitHub::Markdown.render_gfm(text)
    
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      replacement = 
        begin
          Pygments.highlight(pre.text.rstrip, lexer: pre[:lang])
        rescue MentosError
        end
      pre.replace replacement if replacement
    end
    doc.to_s
  end
end