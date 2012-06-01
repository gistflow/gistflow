require 'spec_helper'

describe 'Landing', :local => true do
  before { visit root_path }
  it 'should be available for non-authorized user' do
    page.should have_content('A place to share and improve developer skills')
  end
  
  it 'should have link to login' do
    page.should have_link('Login')
  end
  
  it 'should have link to skip' do
    page.should have_link('Skip')
  end
  
  it 'should hide more block', js: true do
    find('#more').should_not be_visible
  end
  
  it 'should show content by clicking more', js: true do
    click_link 'more'
    find('#more').should be_visible
  end
end
