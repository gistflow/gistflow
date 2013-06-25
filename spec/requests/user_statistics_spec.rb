require 'spec_helper'

describe 'User statistics partial', local: true do
  let!(:user) { create(:user) }

  before do
    visit user_path(user)
  end

  it 'displays statistics section' do
    page.should have_content('Statistics')
  end

  it 'displays count of total views' do
    page.should have_content('Total views')
  end

  it 'displays count of views for last day' do
    page.should have_content('Last day')
  end

  it 'displays count of views for last week' do
    page.should have_content('Last week')
  end

  it 'displays count of views for last month' do
    page.should have_content('Last month')
  end
end
