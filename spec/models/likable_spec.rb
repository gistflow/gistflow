require 'spec_helper'

describe Models::Likable do
  context 'user should be able to like post or comment' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    it "should not be created be post owner" do
      post = FactoryGirl.create(:post, :user => @user)
      @user.like(post).should == false
    end
    
    it "should not be created be post owner" do
      comment = FactoryGirl.create(:comment, :user => @user)
      @user.reload.like(comment).should == false
    end
  end
  
  context 'user should not be able to like comment or post twice' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    it "should be created twice by the same user" do
      post = FactoryGirl.create(:post)
      @user.like(post)
      post.liked_by?(@user).should == true
    end
    
    it "should be created twice by the same user" do
      comment = FactoryGirl.create(:comment)
      @user.like(comment)
      comment.liked_by?(@user).should == true
    end 
  end
end
