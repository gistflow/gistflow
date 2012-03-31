require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionView::Helpers::UrlHelper

describe Replaceable::Taggable do
  describe "replacing hash tags to links" do
    before(:each) do
      @post = FactoryGirl.create(:post_with_tag)
    end
    
    it "should not replace tags if there is no such tag in db" do
      @post.replace_tags!
      @post.content.should_not include(link_to("#tag_1", "tags/tag_1"))
    end
    
    it "should replace tags if they exist in db" do
      FactoryGirl.create(:tag)
      @post.replace_tags!
      @post.content.should include(link_to("#tag_1", "tags/tag_1"))
    end
    
  end
end
