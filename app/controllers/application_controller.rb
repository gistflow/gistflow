class ApplicationController < ActionController::Base
  protect_from_forgery
  
protected
  def recent_posts
    Post.limit(5)
  end
  helper_method :recent_posts

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) || begin
      Account::Cookie.user_by_secret(cookies[:secret])
    end)
  end
  helper_method :current_user
  
  def current_user=(user)
    if @current_user = user
      session[:user_id] = current_user.id
      cookies.permanent[:secret] = current_user.create_cookie_secret
    else
      session[:user_id] = nil
      cookies.delete(:secret)
    end
  end
  helper_method :current_user=
  
  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?

end
