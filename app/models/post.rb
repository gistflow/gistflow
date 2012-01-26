class Post < ActiveRecord::Base
  
  belongs_to :user
  default_scope :order => 'created_at DESC'
  
  def parsed_body
    CGI::escapeHTML(body).gsub(/\{gist:(\d+)\}/) { Github::Gist.script_tag($1) }
  end
end
