class Account::FollowingsController < ApplicationController
  before_filter :authenticate!
  
  def create
    @following = current_user.followings.build(params[:following])
    
    if @following.save
      redirect_to :back, :notice => "You started following @#{@following.followed_user.username}."
    else
      redirect_to :back, :alert => "Something went wrong. Sorry about that."
    end
  end
  
  def destroy
    @following = Following.find(params[:id])
    @following.destroy
    
    redirect_to :back, :notice => "You stopped following @#{@following.followed_user.username}."
  end
end
