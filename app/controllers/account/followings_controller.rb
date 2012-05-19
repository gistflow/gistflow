class Account::FollowingsController < ApplicationController
  before_filter :authenticate!, only: [:create, :destroy]
  
  def create
    @user = find_user(params[:user_id])
    current_user.follow(@user)
    link = render_to_string(inline: "<%= link_to_unfollow(@user) %>")
    render json: { replaceable: link }
  end
  
  def destroy
    @user = find_user(params[:user_id])
    current_user.unfollow(@user)
    link = render_to_string(inline: "<%= link_to_follow(@user) %>")
    render json: { replaceable: link }
  end
  
protected
  
  def find_user(username)
    User.find_by_username(username)
  end
end
