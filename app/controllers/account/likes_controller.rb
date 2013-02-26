class Account::LikesController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = Post.find params[:post_id]
    current_user.like(@post)
    link = {
      icon: 'icon-heart',
      method: 'delete',
      count: @post.reload.likes_count
    }
    render json: link
  end

  def destroy
    @post = Post.find params[:post_id]
    current_user.unlike(@post)
    link = {
      icon: 'icon-heart-empty',
      method: 'post',
      count: @post.reload.likes_count
    }
    render json: link
  end
end