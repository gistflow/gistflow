require 'spec_helper'

describe Posts::ShowPresenter do
  describe 'title and body' do
    let(:post) do
      FactoryGirl.create(:post, :title => "title", :content => "preview<cut>body")
    end
    let(:presenter) { Posts::ShowPresenter.new(post) }
    context 'content with title and body and preview', :focus => true do
      it { presenter.title.should include('title') }
      it { presenter.preview.should include('preview') }
      it { presenter.body.should include('body')  }
    end
    
    context 'context with only title and preview' do
      it { presenter.title.should include('title')  }
      it { presenter.preview.should include('preview')  }
      it { presenter.body.should include('preview')  }
    end
  end
end
