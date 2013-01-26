module Markdown
  def self.markdown(text)
    text = Sanitize.clean(text)
    rendered = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        :autolink            => true,
        :fenced_code_blocks  => true,
        :lax_spacing         => true,
        :filter_html         => true,
        :gh_blockcode        => true,
        :hard_wrap           => true
    )
    html = rendered.render(text)
    
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