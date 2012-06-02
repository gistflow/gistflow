require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
# include ActionView::Helpers::UrlHelper

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
  
  it 'should setup default scope' do
    Post.scoped.where_values_hash.should include(deleted_at: nil)
  end
  
  describe '#mark_deleted?' do
    let(:record) { create(:post) }
    
    it 'should not be for not marked as deleted' do
      record.should_not be_mark_deleted
    end
    
    it 'should be for marked as deleted' do
      record.mark_deleted
      record.should be_mark_deleted
    end
  end
  
  describe '#mark_deleted' do
    let(:record) { create(:post) }
    
    it 'should mark record as deleted' do
      record.mark_deleted
      record.should be_mark_deleted
    end
    
    it 'should assing deleted_at if blank' do
      record.deleted_at = nil
      record.mark_deleted
      record.deleted_at.should be_kind_of(Time)
    end
    
    it 'should not change deleted_at if exists' do
      time = Time.now
      record.deleted_at = time
      record.mark_deleted
      record.deleted_at.should == time
    end
  end
end
