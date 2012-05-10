class UserMailer < ActionMailer::Base
  
  default :from => "info@gistflow.com"
  
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(
      :to => @user.profile.email, 
      :subject => "We are glad to see you at Gistflow.com, #{@user.username}!"
    )
  end
  
end
