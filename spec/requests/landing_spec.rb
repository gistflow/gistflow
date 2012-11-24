require 'spec_helper'

describe 'Landing', :local => true do
  before { visit root_path }
  
  it 'should have call to action' do
    page.should have_content('Join developers community blog, share and learn new skills')
  end
  
  it 'should have link to login' do
    page.should have_link('Login')
  end
  
  it 'should have link to skip' do
    page.should have_link('Skip')
  end  
  
  it 'should redirect to all path when clicking skip' do
    click_link 'Skip'
    current_path.should == all_path
  end
end