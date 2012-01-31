require 'spec_helper'

describe Post do
  describe "#creating posts that includes gists" do
    context 'check that gist tag is parsed properly' do
      let(:post) { Factory(:post_with_gist) }
      it { Posts::ShowPresenter.new(post).body.include?(Github::Gist.script_tag(777)).should == true }
    end
  end
  
  describe 'converting content to title and body' do
    let(:post) { Post.new }
    let(:content) do
      "tratatata aopskdoa skpoda {gist:1023} skpodak pokas opka psk" + 
      " oksaok {gist:10232} asokdopa skopadk opaskopd kpaosk dopkaspo k" + 
      "aposkdopask opkdaspo kpdokasp okdpokas pokdaskdpo kaspokd poksapd k" +
      "aposkdjoas dojs oijodijasoij oiajs oijsaoj oajsi aokdoa kas dkpask" + 
      "paoskd poaksop kdapsok dpokaspok dpoaskpo dksaopk pokas"
    end
    
    it 'should set body as content' do
      post.content = content
      post.body.should == content
    end
    
    it 'should set title as first 255 symbols of content without gists' do
      post.content = content
      post.title.should == 'tratatata aopskdoa skpodaskpodak pokas opka psk oksaokasokdopa skopadk opaskopd kpaosk dopkaspo kaposkdopask opkdaspo kpdokasp okdpokas pokdaskdpo kaspokd poksapd kaposkdjoas dojs oijodijasoij oiajs oijsaoj oajsi aokdoa kas dkpaskpaoskd poaksop kdapsok dpo'
    end
  end
end
