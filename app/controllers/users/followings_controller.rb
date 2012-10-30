class Users::FollowingsController < ApplicationController
  def index
    @user = User.find_by_username!(params[:user_id])
    @users = @user.followed_users.page(params[:page])
  end
end