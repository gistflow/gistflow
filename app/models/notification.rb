class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true

  validates :user_id, :uniqueness => { :scope => [:notifiable_id, :notifiable_type] }
  validates :user, :presence => true
  
  scope :read, where(:read => true)
  scope :unread, where(:read => false)
end