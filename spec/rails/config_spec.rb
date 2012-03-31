require 'spec_helper'

describe 'Rails.config' do
  describe 'admins' do
    it 'should load info from the config file' do
      Rails.application.config.admins.should == %w(releu makaroni4)
    end
  end
end
