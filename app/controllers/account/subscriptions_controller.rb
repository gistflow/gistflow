class Account::SubscriptionsController < ApplicationController
  before_filter :authenticate!, :only => :index
  
  def index
    flash.now[:info] = "<strong>You can only see posts with those tags that you have subscribed</strong>. Click on the tag to subscribe to it."
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