class Account::BookmarksController < ApplicationController
  cache_sweeper :bookmark_sweeper
  cache_sweeper :user_sweeper
  
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = find_post(params[:post_id])
    current_user.bookmark(@post)
    link = render_to_string(inline: "<%= link_to_unbookmark(@post) %>")
    render json: { replaceable: link }
  end
  
  def destroy
    @post = find_post(params[:post_id])
    current_user.unbookmark(@post)
    link = render_to_string(inline: "<%= link_to_bookmark(@post) %>")
    render json: { replaceable: link }
  end
  
protected
  
  def find_post(id)
    Post.find_by_param id
  end
end