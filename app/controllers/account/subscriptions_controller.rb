class Account::SubscriptionsController < ApplicationController
  cache_sweeper :user_sweeper
  cache_sweeper :subscription_sweeper
  
  prepend_before_filter :authenticate!, :only => :index
  
  def index
    @tags = Tag.real.order(:name)
  end
  
  def create
    @tag = find_tag(params[:tag_id])
    current_user.subscribe(@tag)
    link = render_to_string(
      inline: "<%= link_to_unsubscribe(@tag, { onoff: params[:onoff] }) %>"
    )
    render :json => { :replaceable => link }
  end
  
  def destroy
    @tag = find_tag(params[:tag_id])
    current_user.unsubscribe(@tag)
    link = render_to_string(
      inline: "<%= link_to_subscribe(@tag, { onoff: params[:onoff] }) %>"
    )
    render :json => { :replaceable => link }
  end
  
protected
  
  def find_tag(name)
    Tag.find_by_name name
  end
end