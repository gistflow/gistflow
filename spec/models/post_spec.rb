require 'spec_helper'

describe Post do
  let(:post) { create(:post) }
  subject { post }
  
  describe 'cache' do
    let!(:post) { create(:post) }
    
    it 'should cache preview' do
      $redis.get("posts:#{post.id}:preview").should == post.formatted_preview
    end
  end
  
  describe 'observe post for author after create' do
    let(:post) { build(:post) }
    it do
      post.user.should_receive(:observe).with(post).and_return(true)
      post.save
    end
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
  
  describe 'indextank callbacks', :remote => true do
    before do
      $indextank.indexes('postsx_dev').delete rescue IndexTank::NonExistentIndex
      $indextank.indexes('postsx_dev').add :public => false
      begin
        @post = FactoryGirl.create(:post, title: 'foo', content: 'bar bar bar')
      rescue IndexTank::IndexInitializing
        retry
        sleep 0.5
      end
    end
    
    it 'should create a document on indextank' do
      Post.search('foo').should include(@post)
      Post.search('bar').should include(@post)
    end
    
    it 'should update a document on indextank' do
      @post.update_attributes(title: 'baz', content: 'qux')
      Post.search('foo').should_not include(@post)
      Post.search('bar').should_not include(@post)
      Post.search('baz').should include(@post)
      Post.search('qux').should include(@post)
    end
    
    it 'should destroy a document on indextank' do
      @post.destroy
      Post.search('foo').should_not include(@post)
      Post.search('bar').should_not include(@post)
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
end
