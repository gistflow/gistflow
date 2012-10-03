require 'spec_helper'

describe 'Sidebar tags', local: true do
  context 'for unauthorized user' do
    let!(:tags) { 5.times.map { create(:tag) } }
    before { visit all_path }
    
    it 'should not show hints' do
      sidebar.should_not have_css('.content-highlight')
    end
    
    it 'should show popular tags' do
      Tag.popular.each do |tag|
        sidebar.should have_link(tag.with_sign)
      end
    end
    
    it 'should not show link to subscribe for more' do
      sidebar.should_not have_link('Subscribe for more')
    end
  end
  
  def sidebar
    page.find('section.sidebar section.tags')
  end
end