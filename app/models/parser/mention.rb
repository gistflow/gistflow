module Parser
  class Mention
    def initialize(content)
      @content = content
      @raw_usernames = @content.split.map{ |w| w.scan(/^\W*@([\w-]+)/) }.flatten.uniq
    end
    
    def usernames
      users.map &:username
    end
    
    def user_ids
      users.map &:id
    end
  
  protected
    
    def users
      @users ||= begin
        @raw_usernames.any? ? User.where(:username => @raw_usernames) : []
      end
    end
  
  end
end