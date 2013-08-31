class UserMailer < ActionMailer::Base
  
  default :from => 'Gistflow Notifier <info@gistflow.mailgun.org>', reply_to: "info@gistflow.com"
  
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
  
    mail to: @user.profile.email, subject: @notification.mailer_title
  end
  
  def new_post(post_id, user_id)
    @post = Post.find(post_id)
    @user = User.find(user_id)
    
    mail(
      to: @user.profile.email,
      subject: "New Post: #{@post.title}"
    )
  end
end
