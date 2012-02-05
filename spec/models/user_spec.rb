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
      user.favorite_posts << post
    end
    
    it{ user.favorite_posts.should == [post] }
    it{ post.lovers.should == [user] }
  end
  
  describe '#mark_notifications_read' do
    user = Factory(:user)
    post = Factory(:post, :content => "#{Faker::Lorem.paragraph} @#{user.username}}")
    comment = Factory(:comment, :body => "#{Faker::Lorem.paragraph} @#{user.username}}")
    
    before(:each) do
      user.mark_notifications_read
    end
    
    it { user.notifications.unread.count.should == 0 }
  end
end
