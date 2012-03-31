class PostsController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:like, :memorize, :forgot]
  before_filter :authenticate!, :except => [:show, :index]
  
  def index
    @posts = Post.includes(:user).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @presenter = Posts::ShowPresenter.new(@post)
  end

  def new
    @post = Post.new
    @presenter = Posts::FormPresenter.new(@post)
    flash[:info] = "Add your gists to the post by click on gist id."
    render :form
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post
    
    @presenter = Posts::FormPresenter.new(@post)
    render :form
  end

  def create    
    @post = current_user.posts.build(params[:post])
    
    if @post.save
      redirect_to @post
    else
      @presenter = Posts::FormPresenter.new(@post)
      render :form
    end
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post
    
    if @post.update_attributes(params[:post])
      redirect_to @post
    else
      @presenter = Posts::FormPresenter.new(@post)
      render :form
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post
    
    @post.destroy
    redirect_to root_path
  end
  
  def like
    @post = Post.find(params[:id])
    authorize! :like, @post
    
    current_user.like @post
    respond_to do |format|
      format.json do
        new_link = render_to_string(inline: "<%= link_to_like(@post) %>")
        render :json => { :new_link => new_link }
      end
    end
  end
  
  def memorize
    @post = Post.find(params[:id])
    authorize! :memorize, @post
    
    current_user.memorize @post
    render_memorize_link
  end
  
  def forgot
    @post = Post.find(params[:id])
    authorize! :forgot, @post
    
    current_user.forgot @post
    render_memorize_link
  end
  
protected

  def render_memorize_link
    respond_to do |format|
      format.json do
        new_link = render_to_string(inline: "<%= link_to_memorize(@post) %>")
        render :json => { :new_link => new_link }
      end
    end
  end
end