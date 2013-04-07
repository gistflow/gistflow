class ErrorsController < ApplicationController
  layout 'error'
  
  def not_found
    if @user = User.find_by_username(params[:username])
      @posts = @user.posts.with_privacy(@user, current_user).page(params[:page])
      render 'users/show', layout: 'new_application'
    else
      render :not_found, formats: ['html']
    end
  end
end