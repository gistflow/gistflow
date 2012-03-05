class Post::GossipsController < Post::BaseController
  
  def index
    @gossip = current_user.gossips.build if current_user
    super
  end
  
  private
    def model
      Post::Gossip
    end
end