class Account::ProfilesController < ApplicationController
  before_filter :authenticate!
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      redirect_to account_profile_path, :notice => 'Profile was updated.'
    else
      render :edit, :error => 'Smth went wrong.'
    end
  end
end