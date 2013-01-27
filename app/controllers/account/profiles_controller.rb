class Account::ProfilesController < ApplicationController
  prepend_before_filter :authenticate!
  respond_to :js

  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      render json: {}, status: :ok
    else
      render json: { errors: @profile.errors.full_messages.to_sentence }, status: 422
    end
  end
end