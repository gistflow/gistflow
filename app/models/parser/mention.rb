module Parser
  class Mention
    def initialize(content)
      @content = content
      @raw_usernames = @content.split.map{ |w| w.scan(/^\W*@([\w-]+)/) }.flatten.uniq
    end
    
    def usernames
      User.where(:username => @raw_usernames).select(:username).map(&:username)
    end
    
    def user_ids
      User.where(:username => @raw_usernames).select(:id).map(&:id)
    end
  end
end