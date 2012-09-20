require 'spec_helper'

PUNCTUATION = ['.', ',', ':', ';', '?', '!', '(', ')']

describe Replaceable do
  describe '#replace_gists!' do
    let(:replaceable) { Replaceable.new('gist:1, gist:2') }
    before { replaceable.replace_gists! }
    subject { replaceable.to_s }
    
    it 'should replace gists to links' do
      should == '[gist:1](https://gist.github.com/1), [gist:2](https://gist.github.com/2)'
    end
    
    PUNCTUATION.each do |char|
      context "end with #{char}" do
        let(:replaceable) { Replaceable.new("gist:1#{char}") }
        it { should == "[gist:1](https://gist.github.com/1)#{char}" }
      end
    end
  end
  
  describe '#replace_tags!' do
    before { replaceable.replace_tags! }
    subject { replaceable.to_s }
    
    context 'in plain text' do
      let(:replaceable) { Replaceable.new('#tag1, #tag2') }

      it 'should replace tags to links' do
        should == '[#tag1](/tags/tag1), [#tag2](/tags/tag2)'
      end

      PUNCTUATION.each do |char|
        context "end with #{char}" do
          let(:replaceable) { Replaceable.new("#tag#{char}") }
          it { should == "[#tag](/tags/tag)#{char}" }
        end
      end
    end
    
    context 'in links' do
      context 'created with []' do
        let(:replaceable) { Replaceable.new('[link name](http://gistflow.com#tag)') }
        
        it { should == '[link name](http://gistflow.com#tag)' }
      end
      
      context 'created with <>' do
        let(:replaceable) { Replaceable.new('<http://gistflow.com#tag>') }
        
        it 'should not replace tags to links' do
          should == '<http://gistflow.com#tag>'
        end
      end
    end
    
    context 'in code' do
      context 'created with ``````' do
        let(:replaceable) { Replaceable.new("```ruby\n #ruby \n```") }
        
        it { should == "```ruby\n #ruby \n```" }
      end
      
      context 'created with `````` inline', focus: true do
        let(:replaceable) { Replaceable.new("123 ``` #ruby ``` 321") }
        
        it { should == "123 ``` #ruby ``` 321" }
      end
      
      context 'created with ``' do
        let(:replaceable) { Replaceable.new("` #ruby `") }
        
        it { should == "` #ruby `" }
      end
      
      context 'created with ~~~~~~' do
        let(:replaceable) { Replaceable.new("```ruby\n #ruby \n```") }
        
        it { should == "```ruby\n #ruby \n```" }
      end
      
      context 'created with ~~~~~~ inline' do
        let(:replaceable) { Replaceable.new("~~~ #ruby ~~~") }
        
        it { should == "~~~ #ruby ~~~" }
      end
    end
  end
  
  describe '#replace_usernames' do
    before { replaceable.replace_usernames! }
    subject { replaceable.to_s }
    
    context 'unexisted user' do
      let(:replaceable) { Replaceable.new(' @username ') }
      
      it 'should not replace it' do
        should == ' @username '
      end
    end
    
    context 'existed user' do
      before do
        FactoryGirl.create(:user, :username => 'username')
        FactoryGirl.create(:user, :username => 'UserName')
        replaceable.replace_usernames!
      end
      
      context 'wrapped @usename' do
        let(:replaceable) { Replaceable.new(' @username ') }
        it { should == ' [@username](/users/username) ' }
      end
      
      context 'two usernames' do
        let(:replaceable) { Replaceable.new('@username @username') }
        it { should == '[@username](/users/username) [@username](/users/username)' }
      end
      
      context 'started with @username' do
        let(:replaceable) { Replaceable.new('@username ') }
        it { should == '[@username](/users/username) ' }
      end
      
      context 'camel case' do
        let(:replaceable) { Replaceable.new('@UserName') }
        it { should == '[@UserName](/users/UserName)' }
      end
      
      context 'at the end of the line' do
        let(:replaceable) { Replaceable.new(' @username') }
        it { should == ' [@username](/users/username)' }
      end
      
      context 'a part of email' do
        let(:replaceable) { Replaceable.new('foo@username') }
        it { should == 'foo@username' }
      end
      
      context 'a double @username@username' do
        let(:replaceable) { Replaceable.new('@username@username') }
        it do
          # should == '@username@username'
          pending "Is it really needed?"
        end
      end
      
      PUNCTUATION.each do |char|
        context "end with #{char}" do
          let(:replaceable) { Replaceable.new("@username#{char}") }
          it { should == "[@username](/users/username)#{char}" }
        end
      end
    end
  end
  
  describe '#tagnames' do
    let(:replaceable) { Replaceable.new('#tag1, #tag2, #tag3') }
    subject { replaceable.tagnames }
    it { should == %w(tag1 tag2 tag3) }
  end
  
  describe '#usernames' do
    let(:replaceable) { Replaceable.new('@username1, @username2, @username3, @UserName') }
    subject { replaceable.usernames }
    it { should == %w(username1 username2 username3 UserName) }
  end
end
