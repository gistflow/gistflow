require 'spec_helper'

describe 'Viewing posts' do
  context 'in flow' do
    let!(:posts) { 30.times.map { create(:post) } }
    before { visit all_path }
  
    context 'as unauthorized user', js: true do
      it 'should view 20 posts on page' do
        posts.last(20).each do |post|
          page.should have_css('article.post h1', text: post.title)
        end
      end
    
      it 'should be able to view post' do
        page.find('article.post').find_link('Show').click
        page.should have_css('article.post.detail')
      end
    
      include_examples 'inactive buttons'
    end
  end
  
  context 'on detail' do
    let(:post) { create(:post) }
    before { visit post_path(post) }
    
    context 'as unauthorized user', js: true do
      include_examples 'inactive buttons'
    end
  end
end
