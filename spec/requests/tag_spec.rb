require 'spec_helper'

describe 'Tag', local: true do
  describe "tag's page" do
    let!(:tag) { create :tag }
    before { visit tag_path(tag) }
    
    it 'should have title' do
      page.should have_css('header.primary h1', text: tag.name)
    end
    
    it "should show wiki's preview" do
      page.should have_content(tag.wiki.preview)
    end
  end
end