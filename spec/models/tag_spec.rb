require 'spec_helper'

describe Tag do
  let(:tag) { create(:tag) }
  let(:tag_alias) { create(:tag_alias) }
  subject { tag }
  
  it 'should have a alias factory' do
    tag_alias
  end
  
  it 'should create wiki on create' do
    tag.wiki.should be_persisted
  end
  
  describe '#set_entity' do
    describe 'fix taggings' do
      let!(:post) { create(:post) }
      let!(:tag1) { create(:tag) }
      let!(:tag2) { create(:tag) }
    
      it 'should update tagging' do
        post.tags = [tag1]
        tag1.set_entity tag2
        post.tags(true).should == [tag2]
      end
    
      it 'should destroy tagging' do
        post.tags = [tag1, tag2]
        tag1.set_entity tag2
        post.tags(true).should == [tag2]
      end
    end
  
    describe 'fix subscriptions' do
      let!(:user) { create(:user) }
      let!(:tag1) { create(:tag) }
      let!(:tag2) { create(:tag) }
    
      it 'should update tagging' do
        user.tags = [tag1]
        tag1.set_entity tag2
        user.tags(true).should == [tag2]
      end
    
      it 'should destroy tagging' do
        user.tags = [tag1, tag2]
        tag1.set_entity tag2
        user.tags(true).should == [tag2]
      end
    end
  end
  
  describe '#wiki' do
    let!(:first_wiki) { create(:wiki, tag: tag) }
    let!(:last_wiki) { create(:wiki, tag: tag) }
    subject { tag.wiki }
    
    it { should be }
    it { should == last_wiki }
  end
  
  describe('#name=') do
    subject { tag.name }
    before { tag.name = tag_name }
    
    context 'with underscores' do
      let(:tag_name) { 'ruby_on_rails' }
      it { should == 'rubyonrails' }
    end
    
    context 'uppercase' do
      let(:tag_name) { 'RubyOnRails' }
      it { should == 'rubyonrails' }
    end
    
    context 'dashes' do
      let(:tag_name) { 'ruby-on-rails' }
      it { should == 'rubyonrails' }
    end
  end
end
