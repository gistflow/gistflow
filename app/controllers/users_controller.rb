class UsersController < ApplicationController
  def create
    Rails.logger.info "[OMNI] #{omniauth.inspect}"
    account = Account::Github.find_or_create_by_omniauth(omniauth)
    self.current_user = account.user
    redirect_to root_path
  end
  
  def show
    @user = User.find_by_username(params[:id])
    @posts = @user.posts.page(params[:page])
  end
  
protected

  def omniauth
    request.env['omniauth.auth']
  end
end