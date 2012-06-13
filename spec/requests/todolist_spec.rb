require 'spec_helper'

describe 'Todolist partial', local: true do
  let!(:user) { create(:user, username: :releu) }

  context 'for unauthorized user' do
    it 'should be on page' do
      page.should_not have_content('Welcome todolist')
    end
  end

  context 'for authorized user' do
    before do
      auth
    end
    
    context 'with not completed tasks' do
      it 'should be on page' do
        page.should have_content('Welcome todolist')
      end

      it 'should have 8 tasks' do
        find('section.todolist').all('li').size.should eq(8)
      end
    end
    
    context 'without completed tasks' do
      before do
        [ 
          :subscription, 
          :like, 
          :post, 
          :bookmark, 
          :comment, 
          :observing 
        ].each { |factory| send(:create, factory, user: user) }
        create(:following, follower: user)
      end
      
      it 'should not be on page' do
        reload_current_page
        page.should_not have_content('Welcome todolist')
      end
    end
  end
end