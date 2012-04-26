require 'spec_helper'

describe Account::Twitter do
  describe '.create_by_omniauth' do
    let(:user) { create(:user) }
    let(:omniauth) do
      { 'uid'    => '333',
        'credentials' => {
          'token'  => '111',
          'secret' => '222'
        }
      }
    end
    
    subject do
      Account::Twitter.create_by_omniauth(omniauth) do |a|
        a.user = user
      end
    end
    
    it 'should return account' do
      should be_kind_of(Account::Twitter)
    end
    
    it 'should create new account' do
      should be_persisted
    end
    
    describe 'assign attributes' do
      its(:user)       { should == user }
      its(:token)      { should == '111' }
      its(:secret)     { should == '222' }
      its(:twitter_id) { should == 333 }
    end
    
    context 'if record exists' do
      let!(:account) { create(:account_twitter, user: user, twitter_id: 333) }
      
      it 'should return account' do
        should == account
      end
    end
  end
end
