class Posts::ShowPresenter
  extend ActiveModel::Naming
  
  attr_reader :post
  
  def initialize(post)
    @post = post
  end
  
  def preview
    parsed_preview || parsed_title
  end
  
  def body
    Markdown.markdown begin
      parsed_body || parsed_preview || parsed_title
    end
  end
  
  def title
    if parsed_preview
      parsed_title
    else
      "#{post.user.username} wrote"
    end
  end
  
protected

  def content
    post.content
  end
  
  def parsed_title
    @parsed_title ||= parse_content_parts[0]
  end
  
  def parsed_preview
    @parsed_preview ||= parse_content_parts[1]
  end
  
  def parsed_body
    @parsed_body ||= parse_content_parts[2]
  end
  
  def parse_content_parts
    content.gsub("\r", '').split("\n\n", 3)
  end
end