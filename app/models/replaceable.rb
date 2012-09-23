class Replaceable
  REPLACEABLE_TAGS = %w(p li)
  UNREPLAREABLE_TAGS = %w(a em strong code img)
  BASE_REGEXP = '(^|\W){1}%s(\b|\.|,|:|;|\?|!|\(|\)|$){1}'
  
  attr_reader :html
  
  def initialize(html)
    @html = html
    @usernames = []
    @tagnames = []
  end
  
  def replace_gists!
    regexp = Regexp.new(BASE_REGEXP % 'gist:(\d+)')
    @body.gsub!(regexp) do |match|
      "#{$1}[gist:#{$2}](https://gist.github.com/#{$2})#{$3}"
    end
    self
  end
  
  def replace_usernames!
    safe_replace do |html|
      puts "replace: #{html.inspect}"
      regexp = Regexp.new(BASE_REGEXP % '@(\w+)')
      html.gsub!(regexp) do |match|
        username = $2
        if User.where(:username => username).exists?
          @usernames << username
          %{#{$1}<a href="/users/#{username}" title="#{username}">@#{$2}></a>#{$3}}
        else
          match
        end
      end
      html
    end
    self
  end
  
  def replace_tags!
    safe_replace do |html|
      regexp = Regexp.new(BASE_REGEXP % '#(\w+)')
      html.gsub!(regexp) do |match|
        before, raw, after = $1, $2, $3
        tagname = raw.gsub(/[\-_]/, '').downcase
        @tagnames << tagname
        %{#{before}<a href="/tags/#{tagname}" title="#{tagname}">##{raw}</a>#{after}}
      end
      html
    end
    self
  end
  
  def replace_emoji!
    safe_replace do |html|
      html.emojify
    end
    self
  end
  
  def to_s
    html
  end
  
  def tagnames
    replace_tags! if @tagnames.empty?
    @tagnames
  end
  
  def usernames
    replace_usernames! if @usernames.empty?
    @usernames
  end
  
private
  
  def safe_replace
    REPLACEABLE_TAGS.each do |tag|
      replaceable = {}
      @html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        replaceable[md5] = match
        "{extraction-#{md5}}"
      end
      
      puts replaceable.inspect
      
      replaceable.map do |md5, html|
        
        unreplaceable = {}
        UNREPLAREABLE_TAGS.each do |tag|
          html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
            md5 = Digest::MD5.hexdigest(match)
            unreplaceable[md5] = match
            "{extraction-#{md5}}"
          end
        end
        
        puts html.inspect
        
        yield html
        
        html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
          unreplaceable[$1]
        end
      end
      
      @html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
        "\n\n" + replaceable[$1]
      end
    end
  end
end