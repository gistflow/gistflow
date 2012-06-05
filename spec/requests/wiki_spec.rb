require 'spec_helper'

describe 'Wiki' do
  let(:tag) { create(:tag) }
  let(:wiki) { tag.wiki }
  
  describe 'Viewing wiki page' do
    before { visit tag_wiki_path(tag) }
    
    it 'should have primary title' do
      page.should have_css('header.primary h1', text: wiki.title)
    end
    
    it "should show wiki's body" do
      page.should have_content(wiki.body)
    end
  end
  
  describe 'Return to tag' do
    before { visit tag_wiki_path(tag) }
    
    it 'should have a link to tag' do
      page.should have_link 'Return to tag'
    end
    
    it 'should show me tag page'
  end
  
  describe 'History' do
    before { visit tag_wiki_path(tag) }
    
    it 'should have a link to history' do
      within('article.wiki') do
        page.should have_link 'History'
      end
    end
    
    describe 'History page' do
      
    end
    it 'should '
  end
end
