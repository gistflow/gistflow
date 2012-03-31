require 'spec_helper'

describe User do
  describe 'admin factory' do
    subject { FactoryGirl.create(:admin) }
    it { should be_admin }
  end
  
  describe '#create_cookie_secret' do
    let(:user) { FactoryGirl.create(:user) }
    
    it 'should create new cookie account' do
      user.create_cookie_secret
      user.account_cookies.count.should == 1
    end
    
    it 'should return cookie secret value' do
      user.create_cookie_secret.should == user.account_cookies.last.secret
    end
  end

  describe '#favorite posts' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post) }
    
    before(:each) do
      user.memorize post
    end
    
    it{ user.remembrance.should == [post] }
    it{ post.liked_by?(user).should be_true }
  end
  
  describe '#mark_notifications_read' do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, :content => "#{Faker::Lorem.words(5)} @#{user.username}}")
    comment = FactoryGirl.create(:comment, :content => "#{Faker::Lorem.words(5)} @#{user.username}}")
    
    before(:each) do
      user.mark_notifications_read
    end
    
    it { user.notifications.unread.count.should be_zero }
  end
end
