class Account::LikesController < ApplicationController
  before_filter :authenticate!
  respond_to :json
  
  def create
    @like = current_user.likes.create(params[:like])
    @like.post.reload
    link = render_to_string(inline: "<%= link_to_like(@like.post) %>")
    render json: { replaceable: link }
  end
end
