require 'spec_helper'

def should_have_similar_posts_section
  it 'should have similar posts section' do
    page.should have_css('section.similar_posts header h1', text: 'Similar posts')
  end
end

describe 'Similar posts', local: true do
  context 'on post page' do
    let!(:tag) { create :tag }
    let!(:post) { create :post, :tags => [tag] }
    
    context 'when similar posts exist' do
      let!(:similar_post) { create :post, :tags => [tag] }

      before { visit post_path(post) }

      should_have_similar_posts_section

      it 'should have link to similar post' do
        page.should have_link(similar_post.title)
      end

      it 'should have proper number of similar posts' do
        find('section.similar_posts').all('li').size.should eq(post.similar_posts.count)
      end
    end

    context 'when similar posts do not exist' do
      before { visit post_path(post) }

      should_have_similar_posts_section

      it 'should say that there is no similar posts available' do
        page.should have_content('Seems like there is no posts on the topic.')
      end
    end
  end
end