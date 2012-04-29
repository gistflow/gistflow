require 'spec_helper'

describe Following do
  let(:follower) { create :user }
  let(:following) { create :following }

  subject { following }

  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Following.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
end