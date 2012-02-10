module Replaceable
  module Mentionable
    include ActionView::Helpers::UrlHelper
    
    def replace_usernames!
      usernames = Parser::Mention.new(self.content).usernames
      self.content = self.content.split(/ /).map do |word|
        if username = word.scan(/^\W*@([\w-]+)/).flatten.first and usernames.include?(username)
          link_to("@#{username}", "users/#{username}").html_safe
        else
          word
        end
      end.join(' ').html_safe
      self
    end
  end
end