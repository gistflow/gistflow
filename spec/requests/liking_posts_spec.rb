require 'spec_helper'

describe 'Liking posts', js: true do
  context 'on users page' do
    let!(:user) { create(:user, username: :releu) }
    let!(:post) { create(:post, user_id: user.id) }        
    let(:like_button_selector) { "article#post-#{post.id} a.like.button" }
    let(:like_button) { find like_button_selector }
    
    context 'when like post' do
      before do
        auth
        visit all_path
      end

      it 'changes number of likes when click like' do
        like_button.should have_content('0')
        like_button.click
        like_button.should have_content('1')      
      end
    end

    context 'when unlike post' do
      before do
        user.like post
        post.reload
        auth user
        visit all_path
      end

      it 'changes number of likes when click like' do
        like_button.should have_content('1')
        like_button.click
        like_button.should have_content('0')      
      end
    end
  end
end