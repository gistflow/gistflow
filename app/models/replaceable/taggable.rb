module Replaceable
  module Taggable
    TAG = /^\W*\#([\w]+)/
    
    def replace_tags!
      self.content = self.content.split(/ /).map do |word|
        if tag = word.scan(TAG).flatten.first and Tag.where(:name => tag).exists?
          link_to("##{tag}", "tags/#{tag}").html_safe
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
end