require 'spec_helper'

describe Models::Likable do
  context 'user should be able to like post or comment' do
    let(:user) { create(:user) }
    
    it "should not be created by post owner" do
      post = create(:post, :user => user)
      user.reload.like(post).should == false
    end
    
    it "should not be created by post owner" do
      comment = create(:comment, :user => user)
      user.reload.like(comment).should == false
    end
  end
  
  context 'user should not be able to like comment or post twice' do
    let(:user) { create(:user) }
    
    it "should be created twice by the same user" do
      post = create(:post)
      user.like(post)
      post.liked_by?(user).should == true
    end
    
    it "should be created twice by the same user" do
      comment = create(:comment)
      user.like(comment)
      comment.liked_by?(user).should == true
    end 
  end
end
