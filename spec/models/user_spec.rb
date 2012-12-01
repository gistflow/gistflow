require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  it 'should have settings' do
    user.settings.should be_persisted
  end
  
  it 'should have profile' do
    user.profile.should be_persisted
  end
  
  it 'should have token' do
    user.account_token.should be_persisted
  end
  
  describe '#gistflow' do
    subject { User.gistflow }
    it { should be_a_kind_of(User) }
    it { should be_persisted }
  end
  
  describe "#flow" do
    it 'should find post with subscribed tag' do
      tag = create(:subscription, :user => user).tag
      post = create(:post); post.tags = [tag]
      subject.flow.should include(post)
    end
    
    it 'should not find private post with subscribed tag' do
      tag = create(:subscription, user: user).tag
      post = create(:private_post); post.tags = [tag]
      subject.flow.should_not include(post)
    end
    
    it 'should find post by followed user' do
      followed_user = create(:following, follower: user).followed_user
      post = create(:post, user: followed_user)
      subject.flow.should include(post)
    end
    
    it 'should find post by followed user' do
      followed_user = create(:following, follower: user).followed_user
      post = create(:private_post, user: followed_user)
      subject.flow.should_not include(post)
    end
    
    it 'should show self private posts' do
      post = create(:private_post, user: user)
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
  
  describe '#mark_notifications_read' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, :content => "#{Faker::Lorem.words(5)} @#{user.username}} #foo") }
    let!(:comment) { FactoryGirl.create(:comment, :content => "#{Faker::Lorem.words(5)} @#{user.username}}") }
    
    before(:each) do
      user.mark_notifications_read
    end
    
    it { user.notifications.unread.count.should be_zero }
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
