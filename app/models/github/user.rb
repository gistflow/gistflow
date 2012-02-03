module Github
  class User
    def initialize(username)
      @username = username
    end
    
    def gists
      Github::Gist.all_for_user(@username)
    end
  end
end