require 'spec_helper'

describe Posts::ShowPresenter do
  describe 'title and body' do
    context 'content with title and body and preview' do
      let(:post) do
        Factory(:post, :content => %w(title preview body).join("\n\n"))
      end
      let(:presenter) { Posts::ShowPresenter.new(post) }
      
      it { presenter.title.should include('title') }
      it { presenter.preview.should include('preview') }
      it { presenter.body.should include('body')  }
    end
    
    context 'context with only title and preview' do
      let(:post) do
        Factory(:post, :content => %w(title preview).join("\n\n"))
      end
      let(:presenter) { Posts::ShowPresenter.new(post) }
      
      it { presenter.title.should include('title')  }
      it { presenter.preview.should include('preview')  }
      it { presenter.body.should include('preview')  }
    end
    
    context 'context with only title' do
      let(:post) { Factory(:post, :content => 'title') }
      let(:presenter) { Posts::ShowPresenter.new(post) }
      
      it "should display title with username wrote" do
        presenter.title.should == "#{post.user.username} wrote"
      end
      it { presenter.preview.should include('title') }
      it { presenter.body.should include('title') }
    end
  end
end
