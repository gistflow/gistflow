class Post::HomeController < Post::BaseController
  def index
    @posts = Post.includes(:user).page(params[:page])
  end
end
