module Parser
  class Mention
    def initialize(content)
      @content = content
    end
    
    def usernames
      usernames = @content.split.map{ |w| w.scan(/^\W*@([\w-]+)/) }.flatten.uniq
      User.where(:username => usernames).select(:username).map(&:username)
    end
  end
end