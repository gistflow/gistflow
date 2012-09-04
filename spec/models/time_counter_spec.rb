require 'spec_helper'

describe TimeCounter do
  let(:time_counter) { Factory :time_counter }
  subject { time_counter }

  it { should be_valid }
end