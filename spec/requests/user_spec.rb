require 'spec_helper'

describe 'User page', local: true do
  let!(:user_1) { create(:user, username: :releu) }
  let!(:user_2) { create(:user) }
  before do
    auth
    visit user_path(user_2)
  end
  
  context 'self user page' do
  end
  
  context 'other user page' do
    it 'should have right username' do
      page.should have_css('a.username', text: 'releu')
    end
    
    it 'should have follow link' do
      page.should have_css('a', text: 'Follow')
    end
    
    context 'when not following user' do
      before do 
        click_link 'Follow'
      end
      
      it 'should change follow link to unfollow', js: true do
        page.should have_css('a', text: 'Unfollow')
      end

      it 'should increment followers count', js: true do
        find('.followers_count').should have_content('1')
      end
    end

    context 'when following user' do
      before do
        click_link 'Follow'
      end
      
      context 'click unfollow' do
        before { click_link 'Unfollow' }
        
        it 'should change unfollow link to follow', js: true do
          page.should have_link('Follow')
        end

        it 'should decrement followers count', js: true do
          find('.followers_count').should have_content('0')
        end
        
      end
    end
  end
end
