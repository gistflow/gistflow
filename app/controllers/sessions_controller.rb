class SessionsController < ApplicationController
  def create
    self.current_user = User.find_by_email('releu@me.com') || User.last
    redirect_to root_path
  end
  
  def destroy
    self.current_user = nil
    redirect_to root_path
  end
end
