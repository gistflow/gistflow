require 'spec_helper'

describe Location do
  let(:location) { create(:location) }
  subject { location }
  
  it { should be_valid }  
end