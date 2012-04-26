require 'spec_helper'

describe Tag do
  let(:tag) { create(:tag) }
  subject { tag }
  
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
