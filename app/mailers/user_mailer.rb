class UserMailer < ActionMailer::Base
  
  default :from => 'Gistflow Notifier <info@gistflow.com>'
  
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.profile.email, 
      subject: "We are glad to see you at Gistflow.com, #{@user.username}!"
    )
  end
  
  def notification_email(notification_id)
    @notification = Notification.find(notification_id)
    @user = @notification.user
  
    mail to: @user.profile.email, subject: @notification.title
  end
end