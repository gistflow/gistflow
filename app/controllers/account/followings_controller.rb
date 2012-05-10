class Account::FollowingsController < ApplicationController
  before_filter :authenticate!, only: [:create, :destroy]
  
  def index
    @user = find_user(params[:user_id])
    @posts = @user.posts.page(params[:page])
  end
  
  def create
    @user = find_user(params[:user_id])
    @user.followings.create { |following| following.follower = current_user }
    redirect_to @user
  end
  
  def destroy
    @user = find_user(params[:user_id])
    @user.followings.where(follower_id: current_user.id).destroy_all
    redirect_to @user
  end
  
protected
  
  def find_user(username)
    User.find_by_username username
  end
end
