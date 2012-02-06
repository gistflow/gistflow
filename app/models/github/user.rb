module Github
  class User
    def initialize(username)
      @username = username
    end
    
    def gists
      Github::Gist.all(@username)
    end
  end
end