require 'spec_helper'

describe Taggable do
  describe "#assign_tags" do
    before(:each) do
      @post = Factory(:post, :tag_names => "tag_1, tag_2")
    end
    
    it {@post.tags.map(&:name).should == ["tag_1", "tag_2"]}
    it {Tag.count.should == 2}
    it {Post.tagged_with("tag_1").should == [@post]}
    it {Post.tagged_with(["tag_1", "tag_2"]).should == [@post]}
  end
end