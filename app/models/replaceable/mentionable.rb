module Replaceable
  module Mentionable
    include ActionView::Helpers::UrlHelper
    
    def replace_usernames
      usernames = Parser::Mention.new(self.body).usernames
      puts "UN: #{usernames}"
      self.body = self.body.split.map do |word|
        puts word.scan(/@([\w\-]+)[^\.]/).flatten.first
        if username = word.scan(/@([\w\-]+)[^\.]/).flatten.first and usernames.include?(username)
          link_to "@#{username}", "users/#{username}"
        else
          word
        end
      end.join(' ').html_safe
      puts self.body
      self
    end
  end
end