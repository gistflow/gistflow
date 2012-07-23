require 'spec_helper'

describe Like do
  let(:like) { create(:like) }
  subject { like }
  
  it 'should have a factory' do
    should be
  end
end
