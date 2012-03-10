module Models
  module Notifiable
    extend ActiveSupport::Concern
    include ActionView::Helpers::UrlHelper
    
    included do
      after_create :create_notifications
    end
    
    def post
      post = self.class.name == "Comment" ? self.post : self
    end

    def create_notifications
      user_ids = Parser::Mention.new(self.body).user_ids
      user_ids.delete(self.user.id)

      user_ids.each do |user_id|
        Notification.create(
          :user_id         => user_id,
          :notifiable_id   => self.id,
          :notifiable_type => self.class.name
        )
      end
    end
  end
end