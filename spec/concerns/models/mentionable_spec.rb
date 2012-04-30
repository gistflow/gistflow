require 'spec_helper'

describe Models::Mentionable do
  describe "it should notify mentioned about it" do
    let!(:user) { create(:user) }
    subject { user.notifications }
    
    context 'as author' do
      before do
        create(:post, content: "foo #bar @#{user.username}", user: user)
      end
      
      it 'should not create a notification for self' do
        user.notifications.count.should be_zero
      end
    end
    
    context 'as mentioned' do
      before { create(:post, content: "foo #bar @#{user.username}") }
      
      it 'should create notification' do
        user.notifications.count.should == 1
      end
    end
  end
end
