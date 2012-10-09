class Account::ObservingsController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!
  respond_to :json
  
  def create
    @post = find_post(params[:post_id])
    current_user.observe(@post)
    link = render_to_string(inline: "<%= link_to_unobserve(@post) %>")
    render json: { replaceable: link }
  end
  
  def destroy
    @post = find_post(params[:post_id])
    current_user.unobserve(@post)
    link = render_to_string(inline: "<%= link_to_observe(@post) %>")
    render json: { replaceable: link }
  end
  
protected
  
  def find_post(id)
    Post.find_by_param id
  end
end