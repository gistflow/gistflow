class Replaceable
  TAG = /^\W*\#([\w]+)/
  
  include ActionView::Helpers::UrlHelper
  attr_accessor :body
  
  def initialize(body)
    self.body = body
  end
  
  def replace_gists!
    self.body = CGI::escapeHTML(self.body)
    self.body.gsub!(/\{gist:(\d+)\}/) do
      body_tag(:div, "", :class => "gistable", :"data-gist-at" => $1)
    end
    self
  end
  
  def replace_usernames!
    usernames = Parser::Mention.new(self.body).usernames
    self.body = self.body.split(/ /).map do |word|
      if username = word.scan(/^\W*@([\w-]+)/).flatten.first and usernames.include?(username)
        link_to("@#{username}", "/users/#{username}").html_safe
      else
        word
      end
    end.join(' ').html_safe
    self
  end
  
  def replace_tags!
    self.body = self.body.split(/ /).map do |word|
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
    self.body.split(/ /).each do |word|
      if tag = word.scan(TAG).flatten.first
        tag_names << tag 
      end
    end
    tag_names.uniq
  end
end