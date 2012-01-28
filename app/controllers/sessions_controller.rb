class SessionsController < ApplicationController
  def destroy
    current_user = nil
    redirect_to root_path
  end
end
