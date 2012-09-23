require 'spec_helper'

describe Like do
  let(:like) { create(:like) }
  subject { like }
  
  it 'should have a factory' do
    should be
  end
  
  describe '#create' do
    it "should increment post's likes_count" do
      post = create(:post)
      post.likes_count.should == 0
      create(:like, post: post)
      post.reload.likes_count.should == 1
    end
    
    it "should increment users's rating" do
      post = create(:post)
      post.user.rating.should == 0
      create(:like, post: post)
      post.user.reload.rating.should == 1
    end
  end
end
