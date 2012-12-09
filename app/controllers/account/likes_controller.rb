class Account::LikesController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = Post.find params[:post_id]
    current_user.like(@post)
    render_replaceable
  end

  def destroy
  	@post = Post.find params[:post_id]
    current_user.unlike(@post)
    render_replaceable
  end

  private
  def render_replaceable
    link = render_to_string(inline: "<%= current_user.like?(@post.reload) ? link_to_unlike(@post) : link_to_like(@post) %>")
    render json: { replaceable: link }
  end
end