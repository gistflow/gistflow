module Markdown
  def self.markdown(text)
    options = [
      :hard_wrap,
      :filter_html,
      :fenced_code,
      :gh_blockcode,
      :no_intra_emphasis,
      :lax_html_blocks,
      :autolink
    ]
    RedcarpetCompat.new(text, :fenced_code, :gh_blockcode).to_html.html_safe
  end
end
