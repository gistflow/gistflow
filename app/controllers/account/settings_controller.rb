class Account::SettingsController < ApplicationController
  prepend_before_filter :authenticate!
  
  def show
    @settings = current_user.settings
    @profile  = current_user.profile
  end
  
  def update
    @settings = current_user.settings
    if @settings.update_attributes(params[:settings])
      render json: {}, status: :ok
    else
      render json: { errors: @settings.errors.full_messages.to_sentence }, status: 422
    end
  end
end
