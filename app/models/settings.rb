class Settings < ActiveRecord::Base
  attr_accessible :default_wall, :receive_notification_emails
  
  WALLS = %w(all flow)
  
  belongs_to :user
  validates :default_wall, inclusion: { in: WALLS }
  
  def default_wall_action
    { flow: 'flow', all: 'index' }[default_wall.to_sym]
  end
end