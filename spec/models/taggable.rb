require 'spec_helper'

describe Taggable do
  describe "#assign_tags" do
    before(:each) do
      @post = FactoryGirl.create(:post_with_tag)
    end
    
    it {@post.tags.map(&:name).should == ["tag_1"]}
    it {Tag.count.should == 1}
    it {Post.tagged_with("tag_1").should == [@post]}
    it {Post.tagged_with(["tag_1"]).should == [@post]}
  end
  
  describe "#update_posts_counts" do
    before(:each) do
      @post = FactoryGirl.create(:post_with_tag)
    end
    
    it "should increment posts_count for each tag" do
      Tag.last.reload.posts_count.should == 1
    end
    
    it "should decrement posts_count for each tag when post is destroyed" do
      @post.destroy
      Tag.last.reload.posts_count.should == 0
    end
  end
end