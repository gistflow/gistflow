require 'spec_helper'

describe Notifiable do
  describe 'when @user is mentioned in post' do
    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :content => "#{Faker::Lorem.paragraph} @#{@user.username}}")
    end
    
    it "should be created and readed for @user" do
      @user.notifications.count.should == 1
      @user.notifications.first.notifiable.should == @post
    end
  end
  
  describe 'when @user is mentioned in comment' do
    before(:each) do
      @user = Factory(:user)
      @comment = Factory(:comment, :body => "#{Faker::Lorem.paragraph} @#{@user.username}}")
    end
    
    it "should be created for @user" do
      @user.notifications.count.should == 1
      @user.notifications.first.notifiable.should == @comment
    end
  end
end
