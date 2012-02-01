require 'spec_helper'

describe Parser::Mention do
  describe "parsing comments body" do
    
    context 'should give username if comment body contains @username ' do
      comment = Factory(:comment_with_mention)
      it {Parser::Mention.new(comment.body).usernames.should == ["user_1"]}
    end
    
    context 'if comment doesnt has a mention usernames should be an empty array' do
      comment = Factory(:comment)
      it {Parser::Mention.new(comment.body).usernames.should == []}
    end
  end
  
end
