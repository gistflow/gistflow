class Account::SubscriptionsController < ApplicationController
  before_filter :authenticate!, :only => :index
  
  def index
    flash.now[:info] = "#{current_user.username.capitalize}, welcome to Gistflow - developers community based on sharing gists. Feel free to write articles with your github public gists, to use #hash_tags and mention other @users. <strong>And first - subscribe for some tags to get articles you are interested in.</strong> Good luck!"
    @subscriptions = Tag.popular.map do |tag|
      current_user.subscriptions.find_or_initialize_by_tag_id(tag.id)
    end
  end
  
  def create
    current_user.subscriptions.create(params[:subscription])
    redirect_to :back
  end
  
  def destroy
    current_user.subscriptions.find(params[:id]).destroy
    redirect_to :back
  end
end