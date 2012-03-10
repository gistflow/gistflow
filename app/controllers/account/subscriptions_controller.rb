class Account::SubscriptionsController < ApplicationController
  before_filter :authenticate!, :only => :index
  
  def index
    flash.now[:info] = 
    @subscriptions = Tag.popular.map do |tag|
      current_user.subscriptions.find_or_initialize_by_tag_id(tag.id)
    end
  end
  
  def create
    current_user.subscriptions.create(params[:subscription])
    redirect_to :back
  end
  
  def destroy
    current_user.subscriptions.destroy(params[:id])
    redirect_to :back
  end
end