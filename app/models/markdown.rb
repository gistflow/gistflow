module Markdown
  def self.markdown(text)
    ::GitHub::Markdown.render_gfm(text).html_safe
  end
end
