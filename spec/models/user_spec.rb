require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  it 'should have settings' do
    user.settings.should be
  end
  
  it 'should have profile' do
    user.profile.should be
  end
  
  describe "#flow" do
    it 'should find post with subscribed tag' do
      tag = create(:subscription, :user => user).tag
      post = create(:post); post.tags = [tag]
      subject.flow.should include(post)
    end
    
    it 'should find post by followed user' do
      followed_user = create(:following, :follower => user).followed_user
      post = create(:post, :user => followed_user)
      subject.flow.should include(post)
    end
  end
  
  describe '#observe?' do
    let!(:user)          { create(:user) }
    let!(:observed_post) { create(:post) }
    let!(:other_post)    { create(:post) }
    before do
      create(:observing, post: observed_post, user: user)
    end
    subject { user }
    
    it { user.observe?(observed_post).should be_true }
    it { user.observe?(other_post).should be_false }
  end

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
  
  describe '#mark_notifications_read' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, :content => "#{Faker::Lorem.words(5)} @#{user.username}} #foo") }
    let!(:comment) { FactoryGirl.create(:comment, :content => "#{Faker::Lorem.words(5)} @#{user.username}}") }
    
    before(:each) do
      user.mark_notifications_read
    end
    
    it { user.notifications.unread.count.should be_zero }
  end
  
  describe '#twitter_client?', :focus => true do
    context 'account exists' do
      let!(:user) { create(:user) }
      let!(:account_twitter) { create(:account_twitter, user: user) }
      
      its(:twitter_client?) { should be_true }
    end
    
    its(:twitter_client?) { should be_false }
  end
  
  describe '#twitter_client', :focus => true do
    let!(:user) { create(:user) }
    let!(:account_twitter) { create(:account_twitter, user: user) }
    subject { user.twitter_client }
    
    it { should be_kind_of(Twitter::Client) }
    its(:oauth_token) { should == account_twitter.token }
    its(:oauth_token_secret) { should == account_twitter.secret }
  end
  
  describe 'following methods' do
    let(:follower)       { create :user }
    let(:followed_user)  { create :user }
    let(:followed_user2) { create :user }
    let!(:following) do
      create :following, follower: follower, followed_user: followed_user
    end
    let!(:following2) do
      create :following, follower: follower, followed_user: followed_user2
    end
    
    describe '#follow?' do
      it { (!!follower.follow?(followed_user)).should be_true }
    end
  end
end
