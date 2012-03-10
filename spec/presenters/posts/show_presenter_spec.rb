require 'spec_helper'

describe Posts::ShowPresenter do
  describe 'title and body' do
    let(:post) do
      Factory(:post, :title => "title", :content => "preview<cut>body")
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

    context 'context with only title' do
      let(:post) { Factory(:gossip) }
      let(:presenter) { Posts::ShowPresenter.new(post) }
      
      it "should display title with username wrote" do
        presenter.title.should include("#{post.user.username}")
        presenter.title.should include("wrote")
      end
    end
  end
end
