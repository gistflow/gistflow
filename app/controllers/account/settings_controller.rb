class Account::SettingsController < ApplicationController
  before_filter :authenticate!
  
  def show
    @settings = current_user.settings
  end
  
  def update
    if current_user.settings.update_attributes(params[:settings])
      options = { :notice => 'Settings were updated.' }
    else
      options = { :error => 'Smth went wrong.' }
    end
    
    redirect_to account_settings_path, options
  end
end
