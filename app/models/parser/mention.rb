module Parser
  class Mention
    def initialize(content)
      @content = content
    end
    
    def usernames
      usernames = @content.scan(/@([\w\-]+)/).flatten.uniq
      User.where(:username => usernames).select(:username).map(&:username)
    end
  end
end