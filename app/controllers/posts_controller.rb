class PostsController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:like, :memorize, :forgot]
  before_filter :authenticate!, :except => [:show, :index]
  
  def index
    @posts = Post.includes(:user).page(params[:page])
  end

  def show
    @presenter = Posts::ShowPresenter.new(post)
  end

  def new
    post = Post.new
    flash[:info] = "Add your gists to the post by click on gist id."
    @presenter = Posts::FormPresenter.new(post)
    render :form
  end

  def edit
    @presenter = Posts::FormPresenter.new(post)
    render :form
  end

  def create    
    post = Post.new(post_params)
    post.user = current_user
    
    if post.save
      redirect_to post_path(post)
    else
      @presenter = Posts::FormPresenter.new(post)
      render :form
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(post_params)
      redirect_to post
    else
      @presenter = Posts::FormPresenter.new(post)
    end
  end

  def destroy
    current_user.posts.find(params[:id]).destroy
    redirect_to root_path
  end
  
  def like
    @post = post
    current_user.like @post
    respond_to do |format|
      format.json do
        new_link = render_to_string(inline: "<%= link_to_like(@post) %>")
        render :json => { :new_link => new_link }
      end
    end
  end
  
  def memorize
    @post = post
    current_user.memorize @post
    render_memorize_link
  end
  
  def forgot
    @post = post
    current_user.forgot @post
    render_memorize_link
  end
  
protected  
  
  def post
    Post.find(params[:id])
  end

  def render_memorize_link
    respond_to do |format|
      format.json do
        new_link = render_to_string(inline: "<%= link_to_memorize(@post) %>")
        render :json => { :new_link => new_link }
      end
    end
  end
  
  def post_params
    params["#{Post.name.underscore.gsub('/','_')}"]
  end
end