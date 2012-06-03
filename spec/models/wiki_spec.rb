require 'spec_helper'

describe Wiki do
  let(:wiki) { create(:wiki) }
  subject { wiki }
  
  describe '#improve' do
    context 'valid new wiki' do
      let(:content) { { content: 'new wiki content' } }
      let(:user) { create(:user) }

      subject { wiki.improve(content, user) }

      it { should be_a_kind_of(Wiki) }
      it { should be_persisted }
      its(:user) { should == user }
      its(:content) { should == content }
    end
  end
  
  its(:title) { should == "#{wiki.tag.name}'s wiki" }
end
