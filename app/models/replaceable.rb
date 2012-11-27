class Replaceable
  REPLACEABLE_TAGS = %w(p)
  UNREPLACEABLE_TAGS = %w(a em strong code img li)
  BASE_REGEXP = '(\s|\>)%s(\b|\-|\.|,|:|;|\?|!|\(|\)|$){1}'
  
  attr_reader :html
  
  def initialize(html)
    @html = html
    @actions, @usernames, @tagnames = [], [], []
  end
  
  def to_s
    safe_replace do |html|      
      @actions.each do |action|
        html = send("replace_#{action}", html)
      end
      html
    end
    html
  end
  
  def replace(*types)
    @actions += types.uniq
    self
  end
  
  def tagnames
    replace(:tags).to_s if @tagnames.empty?
    @tagnames
  end
  
  def usernames
    replace(:usernames).to_s if @usernames.empty?
    @usernames
  end
  
private
  
  def safe_replace
    # extract replaceable tags
    replaceable = {}
    REPLACEABLE_TAGS.each do |tag|
      @html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        replaceable[md5] = match
        "{extraction-#{md5}}"
      end
    end
    
    # perform replacement
    replaceable = Hash[replaceable.map do |md5, html|
      
      # extract subtags
      unreplaceable = {}
      UNREPLACEABLE_TAGS.each do |tag|
        html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
          # don't modify md5 var
          md6 = Digest::MD5.hexdigest(match)
          unreplaceable[md6] = match
          "{extraction-#{md6}}"
        end
      end
      
      html = yield(html)
      
      # return subtags
      html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
        unreplaceable[$1]
      end
      
      [md5, html]
    end]
    
    # return replaceable tags
    @html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
      replaceable[$1]
    end
  end
  
  def replace_gists(html)
    regexp = Regexp.new(BASE_REGEXP % 'gist:(\d+)')
    html.gsub!(regexp) do |match|
      %{#{$1}<a href="https://gist.github.com/#{$2}">gist:#{$2}</a>#{$3}}
    end
    html
  end
  
  def replace_usernames(html)
    regexp = Regexp.new(BASE_REGEXP % '@([\w-]+)')
    html.gsub(regexp) do |match|
      username = $2
      if User.where(:username => username).exists?
        @usernames << username
        %{#{$1}<a href="/users/#{username}" title="#{username}">@#{$2}</a>#{$3}}
      else
        match
      end
    end
  end
  
  def replace_tags(html)
    regexp = Regexp.new(BASE_REGEXP % '#([\w-]+)')
    html.gsub(regexp) do |match|
      before, raw, after = $1, $2, $3
      tagname = raw.gsub(/[\-_]/, '').downcase
      @tagnames << tagname
      %{#{before}<a href="/tags/#{tagname}" title="#{tagname}">##{raw}</a>#{after}}
    end
  end
  
  def replace_emoji(html)
    html.emojify
  end
end