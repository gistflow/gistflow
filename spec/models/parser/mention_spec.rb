require 'spec_helper'

describe Parser::Mention do
  describe "parsing body for usernames" do
    
    context 'mentioning users' do
      
      let(:user_1) { FactoryGirl.create(:user) }
      let(:user_2) { FactoryGirl.create(:user) }
      let(:user_3) { FactoryGirl.create(:user) }
      let(:user_4) { FactoryGirl.create(:user) }
      
      it "should find proper usernames in post body" do
        content = ''
        content << "@#{user_1.username}, "
        content << Faker::Lorem.paragraph
        content << " @#{user_3.username} !!!"
        content << " @#{user_2.username} , "
        content << "gmail@#{user_4.username}.com"
        
        (Parser::Mention.new(content).usernames - [user_1, user_2, user_3].map(&:username)).should == []
      end
    end
    
    context 'if comment doesnt has a mention usernames should be an empty array' do
      comment = FactoryGirl.create(:comment)
      it {Parser::Mention.new(comment.content).usernames.should == []}
    end
    
    context 'should not parse emails' do
      comment = FactoryGirl.create(:comment)
      it {Parser::Mention.new(comment.content).usernames.should == []}
    end
  end
  
end
