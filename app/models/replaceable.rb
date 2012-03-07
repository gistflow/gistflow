class Replaceable
  TAG = /^\W*\#([\w]+)/
  
  include ActionView::Helpers::UrlHelper
  attr_accessor :body
  
  def initialize(body)
    self.body = body
  end
  
  def replace_gists!
    self.body = body.gsub(/\{gist:(\d+)\}/) do |match|
      id = match[/(\d+)/, 1]
      link = link_to "gist #{id}", "https://gist.github.com/#{id}"
      content_tag(:div, link, :class => :gistable, :'data-gist-id' => id)
    end
    self
  end
  
  def replace_usernames!
    # need fixes
    # usernames = Parser::Mention.new(body).usernames
    # self.body = body.split(' ').map do |word|
    #   if username = word.scan(/^\W*@([\w-]+)/).flatten.first and usernames.include?(username)
    #     link_to("@#{username}", "/users/#{username}").html_safe
    #   else
    #     word
    #   end
    # end.join(' ')
    self
  end
  
  def replace_tags!
    # need fixes
    # self.body = body.split(' ').map do |word|
    #   if tag = word.scan(TAG).flatten.first and Tag.where(:name => tag).exists?
    #     link_to("##{tag}", "/tags/#{tag}")
    #   else
    #     word
    #   end
    # end.join(' ').html_safe
    self
  end
  
  def tag_names
    tag_names = []
    body.split(' ').each do |word|
      tag_names << tag if tag = word.scan(TAG).flatten.first
    end
    tag_names.uniq
  end
end