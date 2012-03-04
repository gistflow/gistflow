class UserKitsController < ApplicationController
  def create
    current_user.user_kits.create(params[:user_kit])
    redirect_to user_kits_path(current_user)
  end
  
  def destroy
    current_user.user_kits.destroy(params[:id])
    redirect_to user_kits_path(current_user)
  end
end
