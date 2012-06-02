require 'spec_helper'

describe Wiki do
  describe '#improve' do
    context 'valid new wiki' do
      let(:content) { "new wiki content" }
      let(:user) { create(:user) }
      let(:wiki) { create(:wiki) }

      subject { wiki.improve(content, user) }

      it { should be_a_kind_of(Wiki) }
      it { should be_persisted }
      its(:user) { should == user }
      its(:content) { should == content }
    end
  end
  
  describe '#preview' do
  end
end
