class Replaceable
  BASE_REGEXP = '(^|\W){1}%s(\b|\.|,|:|;|\?|!|\(|\)|$){1}'
  
  attr_reader :body, :tagnames, :usernames
  
  def initialize(body)
    @body = body
    @actions = []
    @usernames = []
    @tagnames = []
  end
  
  def replace_gists!
    @actions << :replace_gists!
  end
  
  def replace_usernames!
    @actions << :replace_usernames!
    self
  end
  
  def replace_tags!
    @actions << :replace_tags!
    self
  end
  
  def replace_emoji!
    self.body = self.body.emojify    
    self
  end
  
  def to_s
    splitted_body.map do |text|
      if text.replaceable?
        @actions.each do |action|
          text = send("perform_#{action}", text)
        end
        text
      else
        text
      end
    end.join
  end
  
private

  def splitted_body
    buffer = ReplaceableString.new
    in_element = false
    splits = []
    chars = body.chars.to_a
    chars.each_with_index do |char, index|
      buffer << char

      if buffer[-3, 3] == "```"
        if in_element = !in_element
          buffer_before = buffer[0...-3]
          buffer_before.replaceable = true
          splits << buffer_before
          
          buffer = buffer[-3, 3]
        else
          buffer.replaceable = false
          splits << buffer
          buffer = ReplaceableString.new
        end
      end
      
      if index.next == chars.size
        buffer.replaceable = true
        splits << buffer
      end
    end
    splits.compact
  end
  
  def perform_replace_gists!(text)
    regexp = Regexp.new(BASE_REGEXP % 'gist:(\d+)')
    text.gsub!(regexp) do |match|
      "#{$1}[gist:#{$2}](https://gist.github.com/#{$2})#{$3}"
    end
    text
  end
  
  def perform_replace_usernames!(text)
    regexp = Regexp.new(BASE_REGEXP % '@(\w+)')
    text.gsub!(regexp) do |match|
      username = $2
      if User.where(:username => username).exists?
        "#{$1}[@#{$2}](/users/#{username})#{$3}"
      else
        match
      end
    end
    text
  end
  
  def perform_replace_tags!(text)
    regexp = Regexp.new(BASE_REGEXP % '#(\w+)')
    text.gsub!(regexp) do |match|
      before, raw, after = $1, $2, $3
      tagname = raw.gsub(/[\-_]/, '').downcase
      "#{before}[##{raw}](/tags/#{tagname})#{after}"
    end
    text
  end
end