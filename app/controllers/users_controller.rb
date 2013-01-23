class UsersController < ApplicationController
  def create
    Rails.logger.info "[omni] #{omniauth.inspect}"
    account = Account::Github.find_or_create_by_omniauth(omniauth)
    self.current_user = account.user
    redirect_to current_user.newbie? ? all_path : root_path
  rescue => e
    Rails.logger.info "[omni][error] #{e}"
    Rails.logger.info "[omni][error] #{e.backtrace.join("\n")}"
    raise e
  end
  
  def show
    if @user = User.includes(:profile).find_by_username(params[:id])
      @posts = @user.posts.with_privacy(@user, current_user).page(params[:page])
      respond_to do |format|
        format.html
        format.rss { render 'posts/index', :layout => false }
      end
    else
      respond_to do |format|
        format.html { render 'search/nothing' }
        format.rss { @posts = []; render 'posts/index', :layout => false }
      end
    end
  end

protected
  
  def omniauth
    request.env['omniauth.auth']
  end
end