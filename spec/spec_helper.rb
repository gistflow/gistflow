ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.filter_run_excluding :remote => true
  config.before(:suite) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
    config = YAML.load_file("#{Rails.root}/config/admins.yml")
    Rails.application.config.admins = config['usernames']
  end
  config.infer_base_class_for_anonymous_controllers = false
end