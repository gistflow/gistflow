class HomeController < PostsController
  def index
    if params[:text]
      @posts = Post.includes(:user).search(params[:text]).page(params[:page])
    else
      @posts = Post.includes(:user).page(params[:page])
    end
  end
end
