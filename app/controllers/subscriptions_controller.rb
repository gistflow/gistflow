class SubscriptionsController < ApplicationController
  def create
    current_user.subscriptions.create(params[:subscription])
    redirect_to :back
  end
  
  def destroy
    current_user.subscriptions.destroy(params[:id])
    redirect_to :back
  end
end