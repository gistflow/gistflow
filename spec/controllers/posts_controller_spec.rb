require 'spec_helper'

describe PostsController do
  render_views
  let!(:post) { create :post }

  describe 'GET show' do
    it 'increments page_views' do
      expect {
        get :show, :id => post.to_param        
      }.to change { post.reload.page_views }.by(1)
    end
  end
end