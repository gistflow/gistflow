require 'spec_helper'

describe Post do
  describe "#creating posts that includes gists" do
    context 'check that gist tag is parsed properly' do
      
    end
  end
  
  describe 'indextank callbacks' do
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
end
