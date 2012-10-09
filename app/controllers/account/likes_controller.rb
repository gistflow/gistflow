class Account::LikesController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = Post.find_by_param params[:post_id]
    current_user.like(@post)
    link = render_to_string(inline: "<%= link_to_liked(@post.reload) %>")
    render json: { replaceable: link }
  end
end
