module Models
  module Notifiable
    extend ActiveSupport::Concern
    include ActionView::Helpers::UrlHelper
    
    included do
      after_create :create_notifications
      has_many :notifications, :as => :notifiable, :dependent => :destroy
    end

    def create_notifications
      usernames = Replaceable.new(body).usernames
      usernames.delete(user.username)

      usernames.each do |username|
        Notification.create! do |n|
          n.user = User.find_by_username(username)
          n.notifiable = self
        end
      end
    end
  end
end