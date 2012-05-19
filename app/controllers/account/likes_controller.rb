class Account::LikesController < ApplicationController
  before_filter :authenticate!
  respond_to :json
  
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    link = render_to_string(inline: "<%= link_to_liked(@post.reload) %>")
    render json: { replaceable: link }
  end
end
