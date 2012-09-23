class Replaceable
  BASE_REGEXP = '(^|\W){1}%s(\b|\.|,|:|;|\?|!|\(|\)|$){1}'
  
  attr_accessor :body
  alias to_s body
  
  def initialize(body)
    self.body = body
  end
    
  def replace_gists!
    regexp = Regexp.new(BASE_REGEXP % 'gist:(\d+)')
    self.body.gsub!(regexp) do |match|
      "#{$1}[gist:#{$2}](https://gist.github.com/#{$2})#{$3}"
    end
    self
  end
  
  def replace_usernames!
    regexp = Regexp.new(BASE_REGEXP % '@(\w+)')
    self.body.gsub!(regexp) do |match|
      username = $2
      if User.where(:username => username).exists?
        "#{$1}[@#{$2}](/users/#{username})#{$3}"
      else
        match
      end
    end
    self
  end
  
  def replace_tags!
    regexp = Regexp.new(BASE_REGEXP % '#(\w+)')
    self.body.gsub!(regexp) do |match|
      before, raw, after = $1, $2, $3
      tagname = raw.gsub(/[\-_]/, '').downcase
      "#{before}[##{raw}](/tags/#{tagname})#{after}"
    end
    self
  end
  
  def replace_emoji!
    self.body = self.body.emojify    
    self
  end

  def tagnames
    body.to_s.scan(Regexp.new(BASE_REGEXP % '#(\w+)')).map do |match|
      match[1].gsub(/[\-_]/, '').downcase
    end.uniq
  end
  
  def usernames
    body.scan(Regexp.new(BASE_REGEXP % '@(\w+)')).map do |match|
      match[1]
    end.uniq
  end
end