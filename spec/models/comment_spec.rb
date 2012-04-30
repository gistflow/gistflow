require 'spec_helper'

describe Comment do
  
  describe 'observe post after create' do
    let(:comment) { build(:comment) }
    
    it do
      comment.user.should_receive(:observe).with(comment.post).and_return(true)
      comment.save
    end
  end
end
