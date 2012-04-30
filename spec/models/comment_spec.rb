require 'spec_helper'

describe Comment do
  
  describe 'observe post after create' do
    let(:comment) { build(:comment) }
    
    it do
      comment.user.should_receive(:observe).with(comment.post).and_return(true)
      comment.save
    end
  end
  
  describe 'notify observing about new comment' do
    let!(:post) { create(:post) }
    let!(:user) { create(:user) }
    let!(:observing) { create(:observing, post: post, user: user) }
    
    context 'as author' do
      before { create(:comment, post: post, user: user) }
      
      it 'should not create new notification' do
        user.notifications.count.should be_zero
      end
    end
    
    context 'as observer' do
      before { create(:comment, post: post) }
      
      it 'should create new notification' do
        user.notifications.count.should == 1
      end
    end
    
  end
end
