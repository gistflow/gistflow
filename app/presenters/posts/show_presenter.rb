class Posts::ShowPresenter
  extend ActiveModel::Naming
  
  attr_reader :post
  
  def initialize(post)
    @post = post
  end
  
  def body
    CGI::escapeHTML(post.body).gsub(/\{gist:(\d+)\}/) do
      Github::Gist.script_tag($1)
    end.html_safe
  end
  
  def title
    post.title[0..50]
  end
  
  def method_missing(method)
    post.public_send(method) if post.respond_to? method
  end
end