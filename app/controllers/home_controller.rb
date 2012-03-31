class HomeController < PostsController
  skip_before_filter :authenticate!
  
  def index
    @posts = Post.includes(:user).page(params[:page])
  end
end
