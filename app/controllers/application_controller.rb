class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :user_signed_in?, :current_user
  
protected
  
  def authenticate!
    unless user_signed_in?
      redirect_to root_path, :alert => 'You should be logged in.'
    end
  end
  
  def user_signed_in?
    !!current_user
  end
  
  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) || begin
      Account::Cookie.user_by_secret(cookies[:secret])
    end)
  end

  def current_user=(user)
    if @current_user = user
      session[:user_id] = current_user.id
      cookies.permanent[:secret] = current_user.create_cookie_secret
    else
      session[:user_id] = nil
      cookies.delete(:secret)
    end
  end
end
