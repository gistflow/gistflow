class Account::SubscriptionsController < ApplicationController
  cache_sweeper :subscription_sweeper
  
  before_filter :authenticate!, :only => :index
  before_filter :setup_welcome_info, :if => :current_user_newbie?
  
  def index
    @tags = Tag.popular
  end
  
  def create
    @tag = find_tag(params[:tag_id])
    current_user.subscribe(@tag)
    link = render_to_string(inline: "<%= link_to_unsubscribe(@tag) %>")
    render :json => { :replaceable => link }
  end
  
  def destroy
    @tag = find_tag(params[:tag_id])
    current_user.unsubscribe(@tag)
    link = render_to_string(inline: "<%= link_to_subscribe(@tag) %>")
    render :json => { :replaceable => link }
  end
  
protected
  
  def find_tag(name)
    Tag.find_by_name name
  end
  
  def setup_welcome_info
    flash.now[:info] = %{
      <strong>#{current_user.username.capitalize}<strong>, welcome to Gistflow
       - developers community based on sharing gists. Feel free to write 
       articles with your github public gists, to use #hash_tags and mention 
       other @users. <strong>And first - subscribe for some tags to get 
       articles you are interested in.</strong> Good luck!
    }.html_safe
  end
end