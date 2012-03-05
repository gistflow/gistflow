class Post::BaseController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:like, :memorize, :forgot]

  # include Controllers::Tipable
  
  def index
    @posts = model.includes(:user).page(params[:page])
    render 'posts/index'
  end

  def show
    @presenter = Posts::ShowPresenter.new(post)
    render 'posts/show'
  end

  def new
    post = model.new
    @presenter = Posts::FormPresenter.new(post)
    render 'posts/new'
  end

  def edit
    @presenter = Posts::FormPresenter.new(post)
    render 'posts/edit'
  end

  def create
    post = model.new(post_params)
    post.user = current_user
    if post.save
      redirect_to :action => :index
    else
      @presenter = Posts::FormPresenter.new(post)
      render 'posts/new'
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(params[:post])
      redirect_to :action => :show, :id => post.id
    else
      @presenter = Posts::FormPresenter.new(post)
      render 'posts/edit'
    end
  end

  def destroy
    post.destroy
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
  
  def search
    redirect_to root_path(:q => params[:q].strip)
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