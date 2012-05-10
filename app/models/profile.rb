class Profile < ActiveRecord::Base
  attr_accessible :company, :email, :home_page
  
  belongs_to :user
  
  after_create :send_welcome_email
  
  protected
  
  def send_welcome_email
    UserMailer.welcome_email(user_id).deliver if email?
  end
end