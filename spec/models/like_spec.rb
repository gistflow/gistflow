require 'spec_helper'

describe Like do
  context 'user should be able to like post or comment' do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should not be created be post owner" do
      post = Factory(:post, :user => @user)
      @user.like(post).should == false
    end
    
    it "should not be created be post owner" do
      comment = Factory(:comment, :user => @user)
      @user.reload.like(comment).should == false
    end
  end
  
  context 'user should not be able to like comment or post twice' do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be created twice by the same user" do
      post = Factory(:post)
      @user.like(post)
      @user.like(post).should == false
    end
    
    it "should be created twice by the same user" do
      comment = Factory(:comment)
      @user.like(comment)
      @user.like(comment).should == false
    end 
  end
end
