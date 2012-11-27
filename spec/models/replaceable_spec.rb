require 'spec_helper'

PUNCTUATION = ['.', ',', ':', ';', '?', '!', '(', ')']

describe Replaceable do
  describe '#replace_gists!' do
    let(:replaceable) { Replaceable.new('<p>gist:1, gist:2</p>') }
    before { replaceable.replace(:gists) }
    subject { replaceable.to_s }
    
    it 'should replace gists to links' do
      should == %{<p><a href="https://gist.github.com/1">gist:1</a>, <a href="https://gist.github.com/2">gist:2</a></p>}
    end
    
    PUNCTUATION.each do |char|
      context "end with #{char}" do
        let(:replaceable) { Replaceable.new("<p>gist:1#{char}</p>") }
        it { should == %{<p><a href="https://gist.github.com/1">gist:1</a>#{char}</p>}}
      end
    end
  end
  
  describe '#replace_tags!' do
    before { replaceable.replace(:tags) }
    subject { replaceable.to_s }
    
    context 'in plain text' do
      let(:replaceable) { Replaceable.new('<p>#tag1, #tag2</p>') }

      it 'should replace tags to links' do
        should == %{<p><a href="/tags/tag1" title="tag1">#tag1</a>, <a href="/tags/tag2" title="tag2">#tag2</a></p>}
      end

      PUNCTUATION.each do |char|
        context "end with #{char}" do
          let(:replaceable) { Replaceable.new("<p>#tag#{char}</p>") }
          it { should == %{<p><a href="/tags/tag" title="tag">#tag</a>#{char}</p>} }
        end
      end
    end
    
    context 'with html coded symbol' do
      let(:replaceable) { Replaceable.new('<p>don&#34;t</p>') }
      
      it 'should not replace #34 as tag' do
        should == '<p>don&#34;t</p>'
      end
    end
  end
  
  describe '#replace_usernames' do
    before { replaceable.replace(:usernames) }
    subject { replaceable.to_s }
    
    context 'unexisted user' do
      let(:replaceable) { Replaceable.new('<p> @username </p>') }
      
      it 'should not replace it' do
        should == '<p> @username </p>'
      end
    end
    
    context 'existed user' do
      before do
        FactoryGirl.create(:user, :username => 'username')
        FactoryGirl.create(:user, :username => 'UserName')
        FactoryGirl.create(:user, :username => 'user-name')
      end
      
      context 'wrapped @usename' do
        let(:replaceable) { Replaceable.new('<p> @username </p>') }
        it { should == '<p> <a href="/users/username" title="username">@username</a> </p>' }
      end
      
      context 'two usernames' do
        let(:replaceable) { Replaceable.new('<p>@username @username</p>') }
        it { should == '<p><a href="/users/username" title="username">@username</a> <a href="/users/username" title="username">@username</a></p>' }
      end
      
      context 'started with @username' do
        let(:replaceable) { Replaceable.new('<p>@username </p>') }
        it { should == '<p><a href="/users/username" title="username">@username</a> </p>' }
      end
      
      context 'camel case' do
        let(:replaceable) { Replaceable.new('<p>@UserName</p>') }
        it { should == '<p><a href="/users/UserName" title="UserName">@UserName</a></p>' }
      end
      
      context 'at the end of the line' do
        let(:replaceable) { Replaceable.new('<p> @username</p>') }
        it { should == '<p> <a href="/users/username" title="username">@username</a></p>' }
      end
      
      context 'a part of email' do
        let(:replaceable) { Replaceable.new('<p>foo@username</p>') }
        it { should == '<p>foo@username</p>' }
      end
      
      context 'a double @username@username' do
        let(:replaceable) { Replaceable.new('<p>@username@username</p>') }
        it do
          # should == '@username@username'
          pending "Is it really needed?"
        end
      end

      context 'with hyphen' do
        let(:replaceable) { Replaceable.new('<p>@user-name</p>') }

        it { should == '<p><a href="/users/user-name" title="user-name">@user-name</a></p>' }
      end
      
      PUNCTUATION.each do |char|
        context "end with #{char}" do
          let(:replaceable) { Replaceable.new("<p>@username#{char}</p>") }
          it { should == %{<p><a href="/users/username" title="username">@username</a>#{char}</p>} }
        end
      end
    end
  end
  
  describe '#tagnames' do
    let(:replaceable) { Replaceable.new('<p>#tag1, #tag2, #tag3</p>') }
    subject { replaceable.tagnames }
    it { should == %w(tag1 tag2 tag3) }
  end
  
  describe '#usernames', focus: true do
    let!(:usernames) { %w(username1 username2 username3 UserName) }
    let!(:users) { usernames.map { |u| FactoryGirl.create(:user, :username => u) } }
    subject { Replaceable.new("<p>#{usernames.map { |u| "@#{u}" }.join(', ')}</p>").usernames }
    
    it { should == %w(username1 username2 username3 UserName) }
  end
end
