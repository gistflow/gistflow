module Replaceable
  module Taggable
    def replace_tags!
      self.content = self.content.split(/ /).map do |word|
        if tag = word.scan(/^\W*\#([\w]+)/).flatten.first and Tag.where(:name => tag).exists?
          link_to("##{tag}", "tags/#{tag}").html_safe
        else
          word
        end
      end.join(' ').html_safe  
      self
    end
  end
end