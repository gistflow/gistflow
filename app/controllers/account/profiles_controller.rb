class Account::ProfilesController < ApplicationController
  before_filter :authenticate!
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    if current_user.profile.update_attributes(params[:profile])
      options = { :notice => 'Profile was updated.' }
    else
      options = { :error => 'Smth went wrong.' }
    end
    
    redirect_to account_profile_path, options
  end
end