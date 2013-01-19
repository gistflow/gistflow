require 'spec_helper'

describe 'User page', local: true, js: true do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user) }
  
  context 'other user page' do
    before do
      auth(user_1)
      visit user_path(user_2)
    end

    it 'should have right username' do
      page.should have_css('section.sidebar section.user ul.contacts a', text: "@#{user_2.username}")
    end
    
    it 'should have follow link' do
      within('section.sidebar section.user') do
        page.should have_css('a', text: 'Follow')
      end
    end
    
    context 'when not following user' do
      before do
        find('a.button.follow').click
      end
      
      it 'should change follow link to unfollow', js: true do
        within('section.sidebar section.user') do
          page.should have_css('a', text: 'Unfollow')
        end
      end

      it 'should increment followers count', js: true do
        find('.followers_count').should have_content('1')
      end
    end

    context 'when following user' do
      before do
        user_1.follow user_2
      end
      
      it 'should change unfollow link to follow', js: true do
        within('section.sidebar section.user') do
          page.should have_link('Follow')
        end
      end

      it 'should decrement followers count', js: true do
        find('.followers_count').should have_content('0')
      end
    end
  end
end