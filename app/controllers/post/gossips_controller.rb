class Post::GossipsController < Post::BaseController
  
  def index
    @gossip = current_user.gossips.build
    super
  end
  
  private
    def model
      Post::Gossip
    end
end