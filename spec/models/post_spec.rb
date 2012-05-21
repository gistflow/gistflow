require 'spec_helper'

describe Post do
  let(:post) { create(:post) }
  subject { post }
  
  describe 'observe post for author after create' do
    subject { Observing.where(post_id: post.id, user_id: post.user_id) }
    it { should be_exists }
  end
  
  describe '#tags_size' do
    subject { build(:post, :content => 'foo #bar baz') }
    its(:tags_size) { should == 1 }
  end
  
  describe 'validations' do
    context 'tags count' do
      subject { build(:post, :content => 'foo bar baz') }
      
      it { should be_invalid }
      it { should have(1).errors_on(:tags_size) }
    end
  end
  
  describe '#tweet' do
    let!(:user) { create(:user) }
    let!(:account_twitter) { create(:account_twitter, user: user) }
    let!(:status) { 'foo bar' }
    let!(:post) { build(:post, user: user, status: status) }
    
    context 'if twitter account', :focus => true, :remote => true do
      it 'should tweet after create if status present' do
        user.twitter_client.should_receive(:status).with(status)
        post.save
      end
    end
  end
  
  describe '#title_for_notification' do
    let(:post) { create :post }
    
    it { post.title_for_notification(true).should == post.title }
    it { post.title_for_notification(false).should == post.id }
  end
end
