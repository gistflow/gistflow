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
      if User.where(:username => $2).exists?
        "#{$1}[@#{$2}](/users/#{$2})#{$3}"
      else
        match
      end
    end
    self
  end
  
  def replace_tags!
    regexp = Regexp.new(BASE_REGEXP % '#(\w+)')
    self.body.gsub!(regexp) do |match|
      "#{$1}[##{$2}](/tags/#{$2})#{$3}"
    end
    self
  end
  
  def tagnames
    body.scan(Regexp.new(BASE_REGEXP % '#(\w+)')).map do |match|
      match[1]
    end.uniq
  end
  
  def usernames
    body.scan(Regexp.new(BASE_REGEXP % '@(\w+)')).map do |match|
      match[1]
    end.uniq
  end
end