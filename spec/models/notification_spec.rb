require 'spec_helper'

describe Notification do
  describe 'Notifications, when @user is mentioned in post' do
    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :content => "#{Faker::Lorem.paragraph} @#{@user.username}}")
    end
    
    it "should be created and readed for @user" do
      @user.notifications.count.should == 1
      @user.notifications.first.notifiable.should == @post
      @user.read_notifications
      @user.notifications.unread.should == []
    end
  end
  
  describe 'Notifications, when @user is mentioned in comment' do
    before(:each) do
      @user = Factory(:user)
      @comment = Factory(:comment, :body => "#{Faker::Lorem.paragraph} @#{@user.username}}")
    end
    
    it "should be created for @user" do
      @user.notifications.count.should == 1
      @user.notifications.first.notifiable.should == @comment
      @user.read_notifications
      @user.notifications.unread.should == []
    end
  end
end
