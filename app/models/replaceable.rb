class Replaceable
  TAG = /^\W*\#([\w]+)/
  
  include ActionView::Helpers::UrlHelper
  attr_accessor :content
  
  def initialize(content)
    self.content = content
  end
  
  def replace_gists!
    self.content = CGI::escapeHTML(self.content)
    content.gsub!(/\{gist:(\d+)\}/) do
      content_tag(:div, "", :class => "gistable", :"data-gist-at" => $1)
    end
  end
  
  def replace_usernames!
    usernames = Parser::Mention.new(self.content).usernames
    self.content = content.split(/ /).map do |word|
      if username = word.scan(/^\W*@([\w-]+)/).flatten.first and usernames.include?(username)
        link_to("@#{username}", "/users/#{username}").html_safe
      else
        word
      end
    end.join(' ')
  end
  
  def replace_tags!
    self.content = self.content.split(/ /).map do |word|
      if tag = word.scan(TAG).flatten.first and Tag.where(:name => tag).exists?
        link_to("##{tag}", "/tags/#{tag}").html_safe
      else
        word
      end
    end.join(' ').html_safe  
    self
  end
  
  def tag_names
    tag_names = []
    self.content.split(/ /).each do |word|
      if tag = word.scan(TAG).flatten.first
        tag_names << tag 
      end
    end
    tag_names.uniq
  end
end