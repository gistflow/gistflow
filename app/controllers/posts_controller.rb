class PostsController < ApplicationController
  def index
    @posts = Post.all.map { |p| Posts::ShowPresenter.new(p) }
  end

  def show
    post = Post.find(params[:id])
    @presenter = Posts::ShowPresenter.new(post)
  end

  def new
    post = current_user.posts.build
    @presenter = Posts::FormPresenter.new(post)
  end

  def edit
    post = current_user.posts.find(params[:id])
    @presenter = Posts::FormPresenter.new(post)
  end

  def create
    post = current_user.posts.build(params[:post])
    if post.save
      redirect_to post, notice: 'Post was successfully created.'
    else
      @presenter = Posts::FormPresenter.new(post)
      render :new
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update_attributes(params[:post])
      redirect_to post, notice: 'Post was successfully updated.'
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
end
