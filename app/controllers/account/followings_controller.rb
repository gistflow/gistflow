class Account::FollowingsController < ApplicationController
  before_filter :authenticate!, only: [:create, :destroy]
  
  def create
    @following = current_user.followings.create(params[:following])
    render_link
  end
  
  def destroy
    @following = current_user.followings.find(params[:id]).destroy
    render_link
  end
  
protected
  
  def render_link
    link = render_to_string(inline: "<%= link_to_follow(@following.followed_user) %>")
    render json: { replaceable: link }
  end
end
