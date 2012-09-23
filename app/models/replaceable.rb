class Replaceable
  REPLACEABLE_TAGS = %w(p li)
  UNREPLAREABLE_TAGS = %w(a em strong code img)
  BASE_REGEXP = '(\s|\>)%s(\b|\-|\.|,|:|;|\?|!|\(|\)|$){1}'
  
  attr_reader :html
  
  def initialize(html)
    @html = html
    @actions, @usernames, @tagnames = [], [], []
  end
  
  def to_s
    safe_replace do |html|
      @actions.each do |action|
        send "replace_#{action}", html
      end
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
    REPLACEABLE_TAGS.each do |tag|
      replaceable = {}
      @html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        replaceable[md5] = match
        "{extraction-#{md5}}"
      end
      
      replaceable.map do |md5, html|
        
        unreplaceable = {}
        UNREPLAREABLE_TAGS.each do |tag|
          html.gsub!(%r{<#{tag}>.*?</#{tag}>}m) do |match|
            md5 = Digest::MD5.hexdigest(match)
            unreplaceable[md5] = match
            "{extraction-#{md5}}"
          end
        end
        
        yield html
        
        html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
          unreplaceable[$1]
        end
      end
      
      @html.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
        replaceable[$1]
      end
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
    regexp = Regexp.new(BASE_REGEXP % '@(\w+)')
    html.gsub!(regexp) do |match|
      username = $2
      if User.where(:username => username).exists?
        @usernames << username
        %{#{$1}<a href="/users/#{username}" title="#{username}">@#{$2}</a>#{$3}}
      else
        match
      end
    end
    html
  end
  
  def replace_tags(html)
    regexp = Regexp.new(BASE_REGEXP % '#(\w+)')
    html.gsub!(regexp) do |match|
      before, raw, after = $1, $2, $3
      tagname = raw.gsub(/[\-_]/, '').downcase
      @tagnames << tagname
      %{#{before}<a href="/tags/#{tagname}" title="#{tagname}">##{raw}</a>#{after}}
    end
    html
  end
  
  def replace_emoji(html)
    html.emojify
  end
end