class Account::SubscriptionsController < ApplicationController
  before_filter :authenticate!, :only => :index
  before_filter :setup_welcome_info, :if => :current_user_newbie?
  
  def index
    @subscriptions = Tag.popular.map do |tag|
      current_user.subscriptions.find_or_initialize_by_tag_id(tag.id)
    end
  end
  
  def create
    @subscription = current_user.subscriptions.create(params[:subscription])
    @tag = @subscription.tag
    
    request.xhr? ? render_json : redirect_to(:back)
  end
  
  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    
    @tag = subscription.tag
    @subscription = current_user.subscriptions.build(:tag => @tag)
    
    request.xhr? ? render_json : redirect_to(:back)
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
  
  def render_json
    respond_to do |format|
      format.json do
        new_form = render_to_string(inline: "<%= render :partial => 'subscription.html.slim', :locals => {:subscription => @subscription} %>")
        tag_block = render_to_string(inline: "<%= content_tag(:li, link_to_tag(@tag)) %>")
        render :json => { 
          :new_form => new_form, 
          :link_id => @tag.dom_link_id, 
          :tag_block => tag_block
        }
      end
    end
  end
end