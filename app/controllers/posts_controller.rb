class PostsController < ApplicationController
  before_filter :assign_type
  
  def index
    @posts = post_model.page(params[:page])
  end

  def show
    post = post_model.find(params[:id])
    @presenter = Posts::ShowPresenter.new(post)
  end

  def new
    post = post_model.new
    post.user = current_user
    @presenter = Posts::FormPresenter.new(post)
  end

  def edit
    post = current_user.posts.find(params[:id])
    @presenter = Posts::FormPresenter.new(post)
  end

  def create
    post = post_model.new(params[:post])
    post.user = current_user
    if post.save
      redirect_to custom_path || post_path(post)
    else
      @presenter = Posts::FormPresenter.new(post)
      render :new
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(params[:post])
      redirect_to post_path(post), notice: 'Post was successfully updated.'
    else
      @presenter = Posts::FormPresenter.new(post)
      render :edit
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to root_path
  end
  
protected

  def assign_type
    if t = (params[:type] || params[:commit])
      params[:type] = "Post::#{t}"
    end
  end
  
  def post_model
    params[:type].constantize rescue Post
  end
  
  def custom_path
    case params[:source]
    when 'root' then
      root_path
    when 'Post::Article' then
      articles_path
    when 'Post::Community' then
      community_index_path
    when 'Post::Question' then
      questions_path
    end
  end
end
