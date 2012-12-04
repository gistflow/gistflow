#coding: utf-8
require 'spec_helper'

def should_have_private_post_link
  it 'should have private post link' do
    page.should have_xpath("//a[contains(@href,'/posts/#{private_post.private_key}')]")
  end
end

describe 'Private posts', js: true do
  context 'on flow' do
    let!(:posts) { 10.times.map { create(:post) } }
    let!(:private_posts) { 10.times.map { create(:private_post) } }
    
    before { visit all_path }
  
    context 'as unauthorized user' do
      it 'should have only public posts' do
        page.should have_css('article.post h1', count: 10)
      end
    end
    
    context 'when search' do
      let(:private_post) { create(:private_post) }
      
      before do
        visit all_path
        fill_in 'q', :with => private_post.title
        click_button '↩'
      end
      
      it 'should search only public posts' do
        page.should_not have_css('article.post h1', text: private_post.title)
      end
    end
  end
  
  context 'on users page', focus: true do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:private_post) { create(:private_post, user: user) }
    
    before do
      auth(user)
      visit user_path(user)
    end
    
    it 'should have public and private posts' do
      page.should have_css('article.post', count: 2)
    end
    
    should_have_private_post_link
  end
  
  context 'on private post page' do
    let!(:private_post) { create(:private_post) }
    
    before do
      visit post_path(:id => private_post.private_key)
    end
    
    it 'should show private post' do
      page.should have_css('article.post h1', text: private_post.title)  
    end
    
    should_have_private_post_link
  end
end