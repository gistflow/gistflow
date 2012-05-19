class Account::SubscriptionsController < ApplicationController
  cache_sweeper :subscription_sweeper
  
  before_filter :authenticate!, :only => :index
  before_filter :setup_welcome_info, :if => :current_user_newbie?
  
  def index
    @tags = Tag.popular
  end
  
  def create
    @subscription = current_user.subscriptions.create(params[:subscription])
    render_link
  end
  
  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
    render_link
  end
  
protected

  def setup_welcome_info
    flash.now[:info] = %{
      <strong>#{current_user.username.capitalize}<strong>, welcome to Gistflow
       - developers community based on sharing gists. Feel free to write 
       articles with your github public gists, to use #hash_tags and mention 
       other @users. <strong>And first - subscribe for some tags to get 
       articles you are interested in.</strong> Good luck!
    }.html_safe
  end
  
  def render_link
    new_form = render_to_string(inline: "<%= link_to_subscribe(@subscription.tag) %>")
    render :json => { :replaceable => new_form }
  end
end