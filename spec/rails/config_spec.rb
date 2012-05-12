require 'spec_helper'

describe 'Rails.config' do
  describe 'admins' do
    it 'should load info from the config file' do
      usernames = YAML.load_file("#{Rails.root}/config/admins.yml")['usernames']
      Rails.application.config.admins.should == usernames
    end
  end
end
