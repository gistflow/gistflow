class Profile < ActiveRecord::Base
  attr_accessible :company, :email, :home_page
  EMAIL_FORMAT = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  
  belongs_to :user
  after_commit :send_welcome_email, on: :create
  before_save :check_email
  
  protected
  
  def send_welcome_email
    if email_valid?
      Resque.enqueue(Mailer, 'UserMailer', :welcome_email, user_id)
    end
  end
  
  def check_email
    self.email_valid = !!(self.email =~ EMAIL_FORMAT)
    true
  end
end