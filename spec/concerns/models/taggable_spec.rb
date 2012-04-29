require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionView::Helpers::UrlHelper

describe Models::Taggable do
  describe "#subscribe_user" do
    let(:user) { create(:user) }
    let(:post) { build(:post_with_tag, :user => user) }
    
    it 'should subscribe author for tags in the post' do
      Tag.destroy_all
      Subscription.destroy_all
      
      user.subscriptions.should be_empty
      post.save
      user.subscriptions.reload.map(&:tag).flatten.should == post.reload.tags
    end
  end
end
