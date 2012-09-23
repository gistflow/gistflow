module Markdown
  def self.markdown(text)
    options = [
      :hard_wrap,
      :fenced_code,
      :gh_blockcode,
      :no_intra_emphasis,
      :lax_html_blocks,
      :autolink
    ].map { |e| [e, true] }
    
    md = Redcarpet::Markdown.new(GFHTML, Hash[options])
    md.render(text).html_safe
  end
end