class PostsController < ApplicationController
  cache_sweeper :post_sweeper
  cache_sweeper :subscription_sweeper
  cache_sweeper :user_sweeper
  
  before_filter :authenticate!, :except => [:show, :index]
  
  def index
    @posts = Post.not_private.includes(:user).page(params[:page])
    render :index
  end
  alias all index
  
  def flow
    @posts = current_user.flow.page(params[:page])
  end
  
  def bookmarks
    @posts = current_user.bookmarked_posts.page(params[:page])
  end

  def show
    @post = Post.find_by_param params[:id]
    @comment = @post.comments.build if can? :create, :comments
  end

  def new
    @post = Post.new(:content => params[:content])
    flash[:info] = tags_flash_info
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post
  end

  def create    
    @post = current_user.posts.build(params[:post])
    
    if @post.save
      redirect_to_post @post
    else
      flash[:info] = tags_flash_info
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    
    if @post.update_attributes(params[:post])
      redirect_to_post @post
    else
      flash[:info] = tags_flash_info
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    
    @post.mark_deleted
    redirect_to root_path
  end
  
protected
  
  def tags_flash_info
    '<strong>#tagname</strong> will add tag to the post'.html_safe
  end
  
  def redirect_to_post post
    redirect_to post.is_private? ? post_path(:id => post.private_key) : post
  end
end