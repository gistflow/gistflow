require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionView::Helpers::UrlHelper

describe Models::Indestructible do
  it 'should be in post' do
    Post.should include(Models::Indestructible)
  end
  
  it 'should be in comment' do
    Comment.should include(Models::Indestructible)
  end
  
  it 'should prevent destroy action' do
    post = create(:post)
    post.destroy
    post.should_not be_destroyed
  end
end
