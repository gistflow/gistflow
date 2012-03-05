class Posts::BaseController < ApplicationController
  cache_sweeper :post_sweeper, :only => [:like, :memorize, :forgot]

  # include Controllers::Tipable
  
  def index
    @posts = Post.where(:type => params[:type])
      .includes(:user).page(params[:page])
    @gossip = current_user.gossips.build
    render 'posts/index'
  end

  def show
    @presenter = Posts::ShowPresenter.new(post)
  end

  def new
    post = model.new
    @presenter = Posts::FormPresenter.new(post)
  end

  def edit
    @presenter = Posts::FormPresenter.new(post)
  end

  def create
    post = model.new(post_params)
    post.user = current_user
    if post.save
      redirect_to post
    else
      @presenter = Posts::FormPresenter.new(post)
      render 'posts/new'
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(params[:post])
      redirect_to post_path(post)
    else
      @presenter = Posts::FormPresenter.new(post)
      render :edit
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
    params["pots_#{model.name.underscore.gsub('/','_')}"]
  end
end