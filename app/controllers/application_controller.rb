class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from StandardError, :with => :handle_exceptions
  helper_method :user_signed_in?, :current_user, :sidebar_tags
  
protected
  
  def handle_exceptions(exception)
    notify_airbrake(exception) if Rails.env.production?
    raise exception.backtrace.join("\n")
    template = case exception
    when ActiveRecord::RecordNotFound, ActionController::RoutingError then
      'errors/not_found'
    else
      'errors/five_hundred'
    end
    
    render template, :layout => 'error'
  end
  
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
  
  def sidebar_tags
    user_signed_in? ? current_user.tags : Tag.popular
  end
end
