require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionView::Helpers::UrlHelper

describe Models::Taggable do
  describe "#subscribe_author" do
    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post_with_tag, :user => user) }
    
    it 'should subscribe author for tags in the post' do
      Tag.destroy_all
      Subscription.destroy_all
      
      user.subscriptions.should be_empty
      post.save
      
      user.subscriptions.reload.map(&:tag).flatten.should == post.reload.tags
    end
  end
  
  describe "replacing hash tags to links" do
    before(:each) do
      @post = FactoryGirl.create(:post_with_tag)
    end
    
    it 'should not replace tags if there is no such tag in db' do
      Tag.destroy_all
      raw = Replaceable.new(@post.content).replace_tags!
      raw.body.should_not include(link_to("#tag_1", "/tags/tag_1"))
    end
    
    it 'should replace tags if they exist in db' do
      raw = Replaceable.new(@post.content).replace_tags!
      raw.body.should include(link_to("#tag_1", "/tags/tag_1"))
    end
    
  end
end
