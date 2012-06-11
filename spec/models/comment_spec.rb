require 'spec_helper'

describe Comment do
  let(:comment) { create(:comment) }
  
  describe 'observe post after create' do
    subject { Observing.where(post_id: comment.post_id, user_id: comment.user_id) }
    before { comment }
    it { should be_exists }
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
  
  describe 'counter caches' do
    it 'should increment for post' do
      comment.post.reload.comments_count.should eq(1)
    end
    
    context 'when delete comment' do
      before { comment.mark_deleted }
      
      it 'should decrement post comments counter cache' do
        comment.post.reload.comments_count.should eq(0)
      end
    end
  end
end