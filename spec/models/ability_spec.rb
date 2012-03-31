require "spec_helper"
require "cancan/matchers"

describe Ability do
  subject { ability }
  let(:ability) { Ability.new(user) }
  
  context 'Unauthorized user' do
    let(:user) { nil }
    
    it { should be_able_to(:index, :home) }
    it { should be_able_to(:show, :users) }
    it { should be_able_to(:show, :posts) }
    it { should be_able_to(:show, :tags) }
    it { should be_able_to(:show, :searches) }
    it { should be_able_to(:create, :searches) }
  end
  
  context 'Authorized user' do
    
  end
  
  context 'Admin user' do
    let(:user) { FactoryGirl.create(:admin) }
    
    it { should be_able_to(:access, :all) }
  end
end
