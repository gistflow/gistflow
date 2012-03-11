class Replaceable
  TAG = /^\W*\#([\w]+)/
  
  include ActionView::Helpers::UrlHelper
  include ERB::Util
  
  attr_writer :body
  
  def initialize(body)
    self.body = h(body)
  end
  
  def body
    @body.to_s.gsub('&quot;', '"')
  end
  
  def replace_gists!
    self.body = body.gsub(/\{gist:(\d+)\}/) do |match|
      id = match[/(\d+)/, 1]
      link = link_to "gist #{id}", "https://gist.github.com/#{id}"
      content_tag(:div, link, :class => :gistable, :'data-gist-id' => id).
        wrap_with_spaces
    end
    self
  end
  
  def replace_usernames!
    usernames = Parser::Mention.new(body).usernames
    self.body = body.gsub(/(^|\W)@(\w+)/) do |match|
      if username = match[/@(\w+)/, 1] and usernames.include?(username)
        link_to("@#{username}", "/users/#{username}").wrap_with_spaces
      else
        match
      end
    end
    self
  end
  
  def replace_tags!
    self.body = body.gsub(/(^|\W)#(\w+)/) do |match|
      if tag = match[/#(\w+)/, 1] and Tag.where(:name => tag).exists?
        link_to("##{tag}", "/tags/#{tag}").wrap_with_spaces
      else
        match
      end
    end
    self
  end
  
  def tag_names
    body.gsub(/(^|\W)#(\w+)/).map do |match|
      match[/#(\w+)/, 1]
    end.uniq.compact
  end
end