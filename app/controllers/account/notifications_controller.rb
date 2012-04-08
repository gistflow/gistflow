class Account::NotificationsController < ApplicationController
  before_filter :mark_notifications_read
  
  def index
    @notifications = current_user.notifications.page(params[:page])
  end
  
protected
  
  def mark_notifications_read
    current_user.mark_notifications_read
  end
end
