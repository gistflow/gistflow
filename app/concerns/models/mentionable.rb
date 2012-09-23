module Models
  module Mentionable
    extend ActiveSupport::Concern
    
    included do
      after_create :notify_mentioned
    end
    
  protected
    
    def notify_mentioned
      html = Markdown.markdown(content)
      usernames = Replaceable.new(html).usernames
      usernames.delete(user.username)
      usernames.each do |username|
        if user = User.find_by_username(username)
          Notification::Mention.create! do |notification|
            notification.notifiable = self
            notification.user = user
          end
        end
      end
      true
    end
  end
end