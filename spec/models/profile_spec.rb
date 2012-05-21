require 'spec_helper'

describe Profile do
  let(:profile) { create(:user).profile }
  
  it 'should have factory' do
    profile.should be
  end
  
  it 'should have valid email' do
    profile.email_valid.should == true
  end
end