module Markdown
  def self.markdown(text)
    options = [
      :hard_wrap,
      :filter_html,
      :fenced_code,
      :gh_blockcode,
      :no_intra_emphasis,
      :lax_html_blocks,
      :autolink,
    ]
    # m = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    # m.render(text).html_safe
    RedcarpetCompat.new(text, :fenced_code, :gh_blockcode).to_html.html_safe
  end
end
