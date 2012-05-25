class SessionsController < ApplicationController
  def create
    self.current_user = User.find_by_username('releu') || User.last
    redirect_to current_user.newbie? ? all_path : root_path
  end
  
  def destroy
    self.current_user = nil
    redirect_to root_path
  end
end
