class DailyReporter
  class << self
    def send
      users_notifications.each do |user_id, notifications|
        UserMailer.daily_report_email(
          user_id, 
          notifications
        ).deliver unless notifications.empty?
      end
    end
    
    def users_notifications
      Notification.unread.todays.for_daily_reports.group_by(&:user_id)
    end
  end  
end