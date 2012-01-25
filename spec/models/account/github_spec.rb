require 'spec_helper'

describe Account::Github do
  describe '#find_or_create_by_omniauth' do
    let(:auth) do
      
    end
    
    it { Account::Github.should respond_to(:find_or_create_by_omniauth) }
    
    context 'account persisted' do
      let(:account) { Factory(:account_github) }
      let(:auth) { { :token => account.token } }
      
      it 'should find account' do
        Account::Github.find_or_create_by_omniauth(auth[:token]).
          should eq(account)
      end
    end
    
    context 'account not found' do
      let(:auth) { {} }
      
      it 'should create new account'
      it 'should create new user'
    end
  end
end
