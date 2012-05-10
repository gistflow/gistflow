class Account::LikesController < ApplicationController
  before_filter :authenticate!
  respond_to :json
  
  def create
    @post = Post.find(params[:post_id])
    @post.likes.create { |like| like.user = current_user }
    @post.reload
    link = render_to_string(inline: "<%= link_to_like(@post) %>")
    render json: { new_link: link }
  end
end
