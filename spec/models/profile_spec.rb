require 'spec_helper'

describe Profile do
  let(:profile) { create(:user).profile }
  
  it 'should have factory' do
    profile.should be
  end
  
  it 'should have valid email' do
    profile.email_valid.should == true
  end
  
  it 'should send welcome email' do
    emails = ActionMailer::Base.deliveries.select do |email|
      email.to == [profile.email]
    end
    
    emails.should_not be_empty
  end
end