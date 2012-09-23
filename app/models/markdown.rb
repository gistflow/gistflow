module Markdown
  def self.markdown(text)
    ::GitHub::Markdown.render_gfm(text)
  end
end