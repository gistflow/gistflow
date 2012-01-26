module Github
  module Gist
    URL = "https://gist.github.com"
    
    def self.all_for_user(username)
      API.json URI("#{API::URL}/users/#{username}/gists")
    end
    
    def self.script_tag(id)
      "<script src=#{URL}/#{id}.js></script>"
    end
  end
end