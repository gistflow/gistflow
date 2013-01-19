class ApplicationController < ActionController::Base
  enable_authorization
  protect_from_forgery
  
  rescue_from Exception, with: :notify_batman
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::Unauthorized, with: :handle_unauthorized
  helper_method :user_signed_in?, :current_user, :sidebar_tags
  
  prepend_before_filter :token_authentication
  
protected
  
  def authenticated_by_token?
    !!@authenticated_by_token
  end
  
  def current_user_newbie?
    current_user.try(:newbie?)
  end
  
  def handle_unauthorized(exception)
    notify_airbrake(exception)
    flash[:error] = 'You are not authorized to access this page.'
    redirect_to root_path
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
    render 'errors/not_found', :layout => 'error', status: :not_found
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
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    if @current_user = user
      session[:user_id] = current_user.id
    else
      session[:user_id] = nil
    end
  end
  
  def sidebar_tags
    user_signed_in? ? current_user.tags.limit(Tag::DISPLAY_LIMIT) : Tag.popular(Tag::DISPLAY_LIMIT)
  end
  
  def render_json_error(message)
    render :json => { :message => message }, :status => :error
  end
  
  def token_authentication
    if params[:token]
      if self.current_user = User.find_by_token(params[:token])
        @authenticated_by_token = true
      end
    end
    true
  end
end
