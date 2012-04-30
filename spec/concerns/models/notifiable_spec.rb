require 'spec_helper'

describe Models::Notifiable do
  let(:comment_notification) { create(:comment_notification) }
  let(:post_notification)    { create(:post_notification) }
  let(:mention_notification) { create(:mention_notification) }
  
  it 'should has factories' do
    comment_notification.should be
    post_notification.should be
    mention_notification.should be
  end
  # 
  # describe 'when @user is mentioned in post' do
  #   before do
  #     @user = FactoryGirl.create(:user)
  #     @post = FactoryGirl.create(:post, :content => "#{Faker::Lorem.paragraph} @#{@user.username}} #tag")
  #   end
  #   
  #   it "should be created and readed for @user" do
  #     @user.notifications.count.should == 1
  #     @user.notifications.first.notifiable.should == @post
  #   end
  # end
  # 
  # describe 'when @user is mentioned in comment' do
  #   before do
  #     @user = FactoryGirl.create(:user)
  #     @comment = FactoryGirl.create(:comment, :content => "#{Faker::Lorem.paragraph} @#{@user.username}} ")
  #   end
  #   
  #   it "should be created for @user" do
  #     @user.notifications.count.should == 1
  #     @user.notifications.first.notifiable.should == @comment
  #   end
  # end
end
