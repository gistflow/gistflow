class Post::GossipsController < Post::BaseController
  
  def index
    super
    @gossip = current_user.gossips.build if user_signed_in?
  end
  
  private
    def model
      Post::Gossip
    end
end