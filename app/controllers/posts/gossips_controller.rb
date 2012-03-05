class Posts::GossipsController < Posts::BaseController
  
  
  private
    def model
      Post::Gossip
    end
end