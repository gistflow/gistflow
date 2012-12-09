require 'spec_helper'

describe 'Liking posts', js: true do
  context 'on users page' do
    let!(:user) { create(:user, username: :releu) }
    let!(:post) { create(:post, user_id: user.id) }

    before do
      auth
      visit all_path
    end
    
    it 'changes number of likes when click like' do
      like_button = find("article#post-#{post.id} a.like.button")

      like_button.should have_content('0')
      like_button.click
      like_button.should have_content('1')
      like_button.click
      like_button.should have_content('0')
    end
  end
end