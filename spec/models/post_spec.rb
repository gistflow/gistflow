require 'spec_helper'

describe Post do
  let(:post) { create(:post) }
  subject { post }
  
  its(:private_key) { should be }
  its(:likes_count) { should eq(0) }
  
  describe 'observe post for author after create' do
    subject { Observing.where(post_id: post.id, user_id: post.user_id) }
    it { should be_exists }
  end
  
  describe 'should notify audience on create' do
    subject { build(:post) }
    it do
      subject.should_receive(:notify_audience).once
      subject.save
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
  
  describe '#cut_text' do
    context 'with text' do
      subject { create(:post, content: 'preview<cut text="More">body #ruby') }
      
      its(:cut_text) do
        should == 'More'
      end
    end
    
    context 'without text' do
      subject { create(:post, content: 'preview<cut>body #ruby') }
      
      its(:cut_text) do
        should == I18n.translate(:default_cut)
      end
    end
  end
  
  describe '#title_for_notification' do
    let(:post) { create :post }
    
    it { post.title_for_notification(true).should == post.title }
    it { post.title_for_notification(false).should == "post #{post.id}" }
  end
  
  describe 'preview and body' do
    context 'with single cut tag' do
      context 'with text' do
        let(:post) { create(:post, content: 'preview<cut text="More">body #ruby') }

        it 'should separate preview from body' do
          post.preview.should == "preview\n[More](/posts/#{post.to_param})"
          post.body.should == "preview\r\nbody #ruby"
        end
      end

      context 'without text' do
        let(:post) { create(:post, content: 'preview<cut>body #ruby') }

        it 'should separate preview from body' do
          post.preview.should == "preview\n[More under the cut](/posts/#{post.to_param})"
          post.body.should == "preview\r\nbody #ruby"
        end
      end
    end
    
    context 'with more than one cut tag' do
      context 'with text' do
        let(:post) { create(:post, content: 'preview<cut text="More">body #ruby w<cut text="More"> other text') }

        it 'should return array of two elements' do
          post.send(:content_parts).should == ['preview', 'body #ruby w<cut text="More"> other text']
        end
      end
      
      context 'without text' do
        let(:post) { create(:post, content: 'preview<cut>body #ruby <cut> #haskell') }

        it 'should separate preview from body' do
          post.preview.should == "preview\n[More under the cut](/posts/#{post.to_param})"
          post.body.should == "preview\r\nbody #ruby <cut> #haskell"
        end
      end
    end
  end

  describe '#similar_posts' do
    let!(:tag_1) { create :tag }
    let!(:tag_2) { create :tag }
    let!(:tag_3) { create :tag }
    let!(:post) { create :post, :content => "#{Faker::Lorem.sentence} ##{tag_2.name} ##{tag_1.name}" }
    let!(:similar_post_1) { create :post, :content => "#{Faker::Lorem.sentence} ##{tag_3.name} ##{tag_1.name}" }
    let!(:similar_post_2) { create :post, :content => "#{Faker::Lorem.sentence} ##{tag_3.name} ##{tag_1.name} ##{tag_2.name}" }
    let!(:similar_post_4) { create :private_post, :content => "#{Faker::Lorem.sentence} ##{tag_3.name} ##{tag_1.name} ##{tag_2.name}" }

    it 'should find similar post for post' do
      post.similar_posts.should have(2).items
      post.similar_posts.should_not include(post)
    end
  end
end
