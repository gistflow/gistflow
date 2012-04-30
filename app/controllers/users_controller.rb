class UsersController < ApplicationController
  before_filter :find_user, :only => [:follow, :unfollow, :following, :followers]
  
  def create
    Rails.logger.info "[omni] #{omniauth.inspect}"
    account = Account::Github.find_or_create_by_omniauth(omniauth)
    self.current_user = account.user
    if current_user.newbie?
      redirect_to account_subscriptions_path
    else
      redirect_to root_path
    end
  rescue => e
    Rails.logger.info "[omni][error] #{e}"
    Rails.logger.info "[omni][error] #{e.backtrace.join("\n")}"
    raise e
  end
  
  def show
    if @user = User.find_by_username(params[:id])
      @posts = @user.posts.page(params[:page])
    else
      render 'search/nothing'
    end
  end
  
  def follow
    if current_user.follow! @user
      redirect_to :back, :notice => "You started following #{@user.username}."
    else
      redirect_to :back, :alert => "Something went wrong. Sorry about that."
    end
  end
  
  def unfollow
    if current_user.unfollow! @user
      redirect_to :back, :notice => "You stopped following #{@user.username}."
    else
      redirect_to :back, :error => "Something went wrong. Sorry about that."
    end
  end
  
  def following
    @users = @user.followed_users.page(params[:page])
  end
  
  def followers
    @users = @user.followers.page(params[:page])
  end
  
protected
  def find_user
    @user = User.find_by_username(params[:id])
  end

  def omniauth
    request.env['omniauth.auth']
  end
end