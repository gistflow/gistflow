require 'spec_helper'

describe DailyReporter do
  let!(:user) { create :user }
  let!(:following_notification) { create :following_notification, user: user }
  let!(:mention_notification) { create :mention_notification, user: user  }
  let!(:comment_notification) { create :comment_notification, user: user  }
  
  describe '.users_notifications' do
    let(:users_notifications) { DailyReporter.users_notifications }
    
    it 'should coller proper notifications for a user' do
      users_notifications[user.id].count.should == 3
    end
  end
  
  describe '.send' do
    before do
      ActionMailer::Base.deliveries.clear
      DailyReporter.send
    end
    
    it 'should send report to user' do
      emails = ActionMailer::Base.deliveries.select do |email|
        email.to == [user.profile.email]
      end
      
      emails.should_not be_empty
    end
  end
end