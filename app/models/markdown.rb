module Markdown
  def self.markdown(text)
    options = [
      :hard_wrap,
      :fenced_code,
      :gh_blockcode,
      :no_intra_emphasis,
      :lax_html_blocks,
      :autolink
    ]
    
    RedcarpetCompat.new(text, *options).to_html.html_safe
    
    # this code brake text
    # # sanitizing html except images for emoji smiles
    # RedcarpetCompat.new(
    #   Sanitize.clean(text, elements: ['img'], attributes: { 'img' => ['src', 'alt', 'title', 'class', 'width', 'height']}), 
    #   *options
    # ).to_html.html_safe
  end
end