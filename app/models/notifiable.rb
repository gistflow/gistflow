module Notifiable
  def self.included(base)
    base.after_create :create_notifications
  end
  
  def create_notifications
    Parser::Mention.new(self.content).user_ids.each do |user_id|
      Notification.create(
        :user_id => user_id,
        :notifiable_id => self.id,
        :notifiable_type => self.class.name
      )
    end
  end
end