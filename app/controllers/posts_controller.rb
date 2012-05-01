class PostsController < ApplicationController
  before_filter :authenticate!, :except => [:show, :index]
  before_filter :handle_index, :only => :index
  prepend_before_filter :handle_unlogged, :only => [:flow, :all],
    :unless => :user_signed_in?
  
  def index
    @posts = Post.includes(:user).page(params[:page])
    render :index
  end
  alias all index
  
  def flow
    @posts = current_user.intrested_posts.includes(:user).page(params[:page])
  end
  
  def feed
    @posts = current_user.followed_posts.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @presenter = Posts::ShowPresenter.new(@post)
    @comment = @post.comments.build if can? :create, :comments
  end

  def new
    content = ""
    content << "gist:#{params[:gist_id]}" if params[:gist_id]
    content << " ##{params[:gist_lang]} " if params[:gist_lang]
    
    @post = Post.new(:content => content)
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
  
  def handle_unlogged
    redirect_to root_path, :notice => "Sign up to create your own flow!"
  end
  
  def handle_index
    redirect_to flow_path if user_signed_in?
  end
end