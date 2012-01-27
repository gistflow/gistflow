class Posts::ShowPresenter
  extend ActiveModel::Naming
  
  attr_reader :post
  
  def initialize(post)
    @post = post
  end
  
  def title
    post.title
  end
  
  def body
    CGI::escapeHTML(post.body).gsub(/\{gist:(\d+)\}/) do
      Github::Gist.script_tag($1)
    end.html_safe
  end
end