module Replaceable
  module Mentionable
    include ActionView::Helpers::UrlHelper
    
    def replace_usernames
      usernames = Parser::Mention.new(self.body).usernames
      self.body = self.body.split.map do |word|
        if username = word.scan(/^\W*@([\w-]+)/).flatten.first and usernames.include?(username)
          link_to "@#{username}", "users/#{username}"
        else
          word
        end
      end.join(' ').html_safe
      self
    end
  end
end