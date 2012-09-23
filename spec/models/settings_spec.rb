require 'spec_helper'

describe Settings do
  let(:user) { create(:user) }
  let(:settings) { user.settings }
  subject { settings }

  it { should be_valid }
  its(:default_wall) { should eq('all') }
end