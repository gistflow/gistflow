class Post::BaseController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:like, :memorize, :forgot]
  before_filter :authenticate!, :except => [:show, :index]
  
  def index
    if params[:text]
      @posts = Post.includes(:user).search(params[:text])
    else
      @posts = model.includes(:user).page(params[:page])
    end
  end

  def show
    @presenter = Posts::ShowPresenter.new(post)
    render 'post/show'
  end

  def new
    post = model.new
    flash[:info] = "Add your gists to the post by click on gist id."
    @presenter = Posts::FormPresenter.new(post)
    render 'post/new'
  end

  def edit
    @presenter = Posts::FormPresenter.new(post)
    render 'post/edit'
  end

  def create    
    post = model.new(post_params)
    post.user = current_user
    
    if post.save
      redirect_to :action => :index
    else
      @presenter = Posts::FormPresenter.new(post)
      render 'post/new'
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(post_params)
      redirect_to post
    else
      @presenter = Posts::FormPresenter.new(post)
      render 'post/edit'
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
    model.find(params[:id])
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
    params["#{model.name.underscore.gsub('/','_')}"]
  end
end