class Account::BookmarksController < ApplicationController
  cache_sweeper :bookmark_sweeper
  cache_sweeper :user_sweeper
  
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = find_post(params[:post_id])
    current_user.bookmark(@post)
    link = {
      icon: 'icon-bookmark',
      method: 'delete'
    }
    render json: link
  end
  
  def destroy
    @post = find_post(params[:post_id])
    current_user.unbookmark(@post)
    link = {
      icon: 'icon-bookmark-empty',
      method: 'post'
    }
    render json: link
  end
  
protected
  
  def find_post(id)
    Post.find_by_param id
  end
end