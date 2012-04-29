class ApplicationController < ActionController::Base
  enable_authorization
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Exception, with: :notify_batman
  helper_method :user_signed_in?, :current_user, :sidebar_tags
  
protected
  
  def current_user_newbie?
    current_user.try(:newbie?)
  end
  
  def notify_batman(exception)
    if Rails.env.production?
      notify_airbrake(exception)
      render 'errors/five_hundred', :layout => 'error'
    else
      raise exception
    end
  end
  
  def record_not_found(exception)
    if Rails.env.production?
      render 'errors/not_found', :layout => 'error'
    else
      raise exception
    end
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
  
  def render_json_error(message)
    render :json => { :message => message }, :status => :error
  end
end
