require 'set'

shared_examples 'inactive buttons' do
  it 'should not see edit button' do
    page.should_not have_css('article.post a.edit')
  end
  
  it 'should not see bookmark button' do
    page.should_not have_css('article.post a.bookmark')
  end
  
  it 'should not see observe button' do
    page.should_not have_css('article.post a.observe')
  end
end
