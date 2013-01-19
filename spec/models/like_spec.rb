require 'spec_helper'

describe Like do  
  let(:post) { create(:post) }
  let(:like) { create(:like, post: post) }
  subject { like }
  
  it 'should have a factory' do
    should be
  end
  
  describe '#create' do
    before { like.save }
    
    it "increments post's likes_count" do
      post.reload.likes_count.should == 1
    end
    
    it "increments users's rating" do
      post.user.reload.rating.should == 1
    end
  end

  describe '#destroy' do
    let!(:like) { create(:like, post: post) }

    before { like.destroy }

    it "decrements post's likes_count" do
      post.reload.likes_count.should == 0
    end
    
    it "decrements increment users's rating" do
      post.user.reload.rating.should == 0
    end
  end
end
