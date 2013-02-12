class PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token, if: :authenticated_by_token?
  
  cache_sweeper :post_sweeper
  cache_sweeper :subscription_sweeper
  cache_sweeper :user_sweeper
  
  prepend_before_filter :authenticate!, :except => [:show, :index, :leaderboard]
  
  def index
    @posts = Post.not_private.includes(:user).page(params[:page])
    respond_to do |format|
      format.html { render :index }
      format.rss  { render :layout => false }
    end
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
    redirect_to(@post, status: 301) if params[:id] != @post.to_param    
    @comment = @post.comments.build if can? :create, :comments
    @post.update_column(:page_views, @post.page_views + 1)
  end

  def new
    @post = Post.new(:content => params[:content])
    flash[:info] = tags_flash_info
  end

  def edit
    @post = Post.find_by_param params[:id]
    authorize! :edit, @post
  end

  def create    
    @post = current_user.posts.build(params[:post])
    
    if @post.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render json: { location: post_url(@post) }, head: :ok }
      end
    else
      flash[:info] = tags_flash_info
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = Post.find_by_param params[:id]
    authorize! :update, @post
    
    if @post.update_attributes(params[:post])
      redirect_to @post
    else
      flash[:info] = tags_flash_info
      render :edit
    end
  end

  def destroy
    @post = Post.find_by_param params[:id]
    authorize! :destroy, @post
    
    @post.mark_deleted
    redirect_to root_path
  end
  
  def new_private
    @post = Post.new(is_private: true)
    flash[:info] = tags_flash_info
    render :new
  end

  def leaderboard
    @search = Post.reorder(:id).not_private.includes(:user, :tags).ransack(params[:search], search_key: :search)
    @search.sorts = 'page_views desc' if @search.sorts.empty?
    @posts = @search.result.page(params[:page])
  end

protected
  
  def tags_flash_info
    '<strong>#tagname</strong> will add tag to the post'.html_safe
  end
end
