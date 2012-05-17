class PostsController < ApplicationController
  before_filter :authenticate!, :except => [:show, :index]
  before_filter :choose_wall, :only => :index, :if => :user_signed_in?
  
  def index
    @posts = Post.includes(:user).page(params[:page])
    render :index
  end
  alias all index
  
  def flow
    @posts = current_user.intrested_posts.includes(user: [:likes, :observings])
      .page(params[:page])
  end
  
  def following
    @posts = current_user.followed_posts.includes(user: [:likes, :observings]).
      page(params[:page])
  end
  
  def observing
    @posts = current_user.observed.page(params[:page])
  end
  
  def bookmarks
    @posts = current_user.bookmarked_posts.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @presenter = Posts::ShowPresenter.new(@post)
    @comment = @post.comments.build if can? :create, :comments
  end

  def new
    @post = Post.new(:content => params[:content])
    @presenter = Posts::FormPresenter.new(@post)
    
    flash[:info] = "Add your gists to the post by click on add."
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post
    
    @presenter = Posts::FormPresenter.new(@post)
  end

  def create    
    @post = current_user.posts.build(params[:post])
    
    if @post.save
      redirect_to @post
    else
      @presenter = Posts::FormPresenter.new(@post)
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    
    if @post.update_attributes(params[:post])
      redirect_to @post
    else
      @presenter = Posts::FormPresenter.new(@post)
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    
    @post.destroy
    redirect_to root_path
  end
  
protected
  
  def choose_wall
    redirect_to action: current_user.settings.default_wall.to_sym
  end
end