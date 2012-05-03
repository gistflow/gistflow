require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  describe '#intested_posts' do
    before do
      @user = FactoryGirl.create(:user)
      @tag = FactoryGirl.create(:tag)
      @other_post = FactoryGirl.create(:post)
      @subscription = FactoryGirl.create(:subscription, :user => @user, :tag => @tag)
      @intrested_post = FactoryGirl.create(:post)
      @intrested_post.tags << @tag
    end
    
    it 'should find all intrested posts' do
      @user.intrested_posts.should == [@intrested_post]
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

  describe '#favorite posts' do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post) }
    
    before { user.memorize post }
    
    its(:remembrance) { should == [post] }
    it { user.memorized?(post).should be_true }
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
    let(:follower) { create :user }
    let(:followed_user) { create :user }
    let(:followed_user2) { create :user }
    
    context 'following' do 
      let!(:following) { create :following, :follower => follower, :followed_user => followed_user }
      let!(:following2) { create :following, :follower => follower, :followed_user => followed_user2 }
      
      describe '#follow?' do
        it { follower.follow?(followed_user).should == true }
      end
      
      describe '#unfollow!' do
        before do
          follower.unfollow! followed_user
        end
        
        it { follower.followed_users.should == [followed_user2] }
        it { followed_user.followers.should == [] }
        it { followed_user2.followers.should == [follower] }
      end
      
      context 'followed posts' do
        let!(:post) { create :post, :user => followed_user }
        let!(:post2) { create :post, :user => followed_user2 }
        
        describe '#followed_posts' do
          it 'should return posts by followed users' do     
            follower.followed_posts.should == [post2, post]
          end
        end
      end
    end
    
    describe '#follow!' do
      before do
        follower.follow! followed_user
      end
      
      it { follower.followed_users.should == [followed_user] }
      it { followed_user.followers.should == [follower] }
      it 'should raise error if try to follow yourself' do
        follower.follow!(follower).should == false
      end
    end
  end
end
