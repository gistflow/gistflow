require 'spec_helper'

describe Comment do
  describe "#creating comments" do
    
    context 'if comment has an consignee consegnee_id should not be nil' do
      consignee = Factory(:user)
      comment = Factory(:comment_with_consignee)

      it {comment.consignee.should == consignee}
    end
    
    context 'if comment doesnt has an consignee consegnee_id should be nil' do
      consignee = Factory(:user)
      comment = Factory(:comment)

      it {comment.consignee.should == nil}
    end
  end
end
