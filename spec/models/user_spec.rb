require 'spec_helper'

describe User do
  describe '#create_cookie_secret' do
    let(:user) { Factory(:user) }
    
    it 'should create new cookie account' do
      user.create_cookie_secret
      user.account_cookies.count.should == 1
    end
    
    it 'should return cookie secret value' do
      user.create_cookie_secret.should == user.account_cookies.last.secret
    end
  end

  describe '#favorite posts' do
    let(:user) { Factory(:user) }
    let(:post) { Factory(:post) }
    
    before(:each) do
      user.memorize post
    end
    
    it{ user.remembrance.should == [post] }
    it{ post.liked_by?(user).should == true }
  end
  
  describe '#mark_notifications_read' do
    user = Factory(:user)
    post = Factory(:post, :content => "#{Faker::Lorem.words(5)} @#{user.username}}")
    comment = Factory(:comment, :content => "#{Faker::Lorem.words(5)} @#{user.username}}")
    
    before(:each) do
      user.mark_notifications_read
    end
    
    it { user.notifications.unread.count.should == 0 }
  end
end
