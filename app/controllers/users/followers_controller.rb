class Users::FollowersController < ApplicationController
  def index
    @user = User.find_by_username(params[:user_id])
    @users = @user.followers.page(params[:page])
  end
end
