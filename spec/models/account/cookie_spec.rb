require 'spec_helper'

describe Account::Cookie do
  describe '#user_by_secret' do
    context 'cookie account exists' do
      let(:cookie) { FactoryGirl.create(:cookie) }
      
      it 'should return user' do
        Account::Cookie.user_by_secret(cookie.secret).should == cookie.user
      end
    end
    
    context 'cookie account dont exists' do
      it { Account::Cookie.user_by_secret('foo').should be_nil }
    end
  end
  
  describe '#generate_secret!' do
    let(:cookie) { Account::Cookie.new }
    
    it 'should generate random string' do
      cookie.generate_secret!
      cookie.secret.should be
    end
  end
end
