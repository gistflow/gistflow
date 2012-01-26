class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user || User.find(session[:user_id]) || begin
      Account::Cookie.user_by_secret(cookie[:secret])
    end
  end
end
